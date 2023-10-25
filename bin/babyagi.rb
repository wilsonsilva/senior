#!/usr/bin/env ruby
require 'openai'
require 'pinecone'
require 'dotenv'
require 'json'
require 'time'

# Load default environment variables (.env)
Dotenv.load

# Engine configuration

# API Keys
OPENAI_API_KEY = ENV["OPENAI_API_KEY"]
raise "OPENAI_API_KEY environment variable is missing from .env" if OPENAI_API_KEY.nil?

OPENAI_API_MODEL = ENV["OPENAI_API_MODEL"] || "gpt-3.5-turbo"
raise "OPENAI_API_MODEL environment variable is missing from .env" if OPENAI_API_MODEL.nil?

if OPENAI_API_MODEL.downcase.include?("gpt-4")
  puts "\033[91m\033[1m\n*****USING GPT-4. POTENTIALLY EXPENSIVE. MONITOR YOUR COSTS*****\033[0m\033[0m"
end

PINECONE_API_KEY = ENV["PINECONE_API_KEY"]
raise "PINECONE_API_KEY environment variable is missing from .env" if PINECONE_API_KEY.nil?

PINECONE_ENVIRONMENT = ENV["PINECONE_ENVIRONMENT"]
raise "PINECONE_ENVIRONMENT environment variable is missing from .env" if PINECONE_ENVIRONMENT.nil?

# Table config
YOUR_TABLE_NAME = ENV["TABLE_NAME"]
raise "TABLE_NAME environment variable is missing from .env" if YOUR_TABLE_NAME.nil?

# Goal configuation
OBJECTIVE = ENV["OBJECTIVE"]
INITIAL_TASK = ENV["INITIAL_TASK"] || ENV["FIRST_TASK"]

# Model configuration
OPENAI_TEMPERATURE = (ENV["OPENAI_TEMPERATURE"] || 0.0).to_f

# Check if we know what we are doing
raise "OBJECTIVE environment variable is missing from .env" if OBJECTIVE.nil?
raise "INITIAL_TASK environment variable is missing from .env" if INITIAL_TASK.nil?

if OPENAI_API_MODEL.downcase.include?("gpt-4")
  puts "\033[91m\033[1m\n*****USING GPT-4. POTENTIALLY EXPENSIVE. MONITOR YOUR COSTS*****\033[0m\033[0m"
end

# Print OBJECTIVE
puts "\033[94m\033[1m\n*****OBJECTIVE*****\n\033[0m\033[0m"
puts "#{OBJECTIVE}"

puts "\033[93m\033[1m\nInitial task:\033[0m\033[0m #{INITIAL_TASK}"

# Configure OpenAI and Pinecone
OpenAI.api_key = OPENAI_API_KEY
pinecone = Pinecone::Client.new(api_key: PINECONE_API_KEY, environment: PINECONE_ENVIRONMENT)

# Create Pinecone index
table_name = YOUR_TABLE_NAME
dimension = 1536
metric = "cosine"
pod_type = "p1"
unless pinecone.list_indexes.include?(table_name)
  pinecone.create_index(
    table_name, dimension: dimension, metric: metric, pod_type: pod_type
  )
end

# Connect to the index
index = pinecone.index(table_name)

# Task list
task_list = []

def add_task(task)
  task_list.push(task)
end

def get_ada_embedding(text)
  text = text.gsub("\n", " ")
  response = OpenAI::Embedding.create(input: [text], model: "text-embedding-ada-002")
  response["data"][0]["embedding"]
end

def openai_call(prompt, model = OPENAI_API_MODEL, temperature = OPENAI_TEMPERATURE, max_tokens = 100)
  loop do
    begin
      if model.start_with?("llama")
        cmd = ["llama/main", "-p", prompt]
        result = `#{cmd.join(' ')}`
        return result.strip
      elsif !model.start_with?("gpt-")
        response = OpenAI::Completion.create(
          engine: model,
          prompt: prompt,
          temperature: temperature,
          max_tokens: max_tokens,
          top_p: 1,
          frequency_penalty: 0,
          presence_penalty: 0,
          )
        return response.choices[0].text.strip
      else
        messages = [{role: "system", content: prompt}]
        response = OpenAI::Completion.create(
          model: model,
          messages: messages,
          temperature: temperature,
          max_tokens: max_tokens,
          n: 1,
          stop: nil,
        )
        return response.choices[0].message.content.strip
      end
    rescue OpenAI::Error::RateLimitError
      puts "The OpenAI API rate limit has been exceeded. Waiting 10 seconds and trying again."
      sleep(10)
    else
      break
    end
  end
end

def task_creation_agent(objective, result, task_description, task_list)
  prompt = <<~PROMPT
    You are a task creation AI that uses the result of an execution agent to create new tasks with the following objective: #{objective},
    The last completed task has the result: #{result}.
    This result was based on this task description: #{task_description}. These are incomplete tasks: #{task_list.join(', ')}.
    Based on the result, create new tasks to be completed by the AI system that do not overlap with incomplete tasks.
    Return the tasks as an array.
  PROMPT
  response = openai_call(prompt)
  new_tasks = response.split("\n") || [response]
  return new_tasks.map { |task_name| { task_name: task_name } }
end

def prioritization_agent(this_task_id)
  global task_list
  task_names = task_list.map { |t| t[:task_name] }
  next_task_id = this_task_id.to_i + 1
  prompt = <<~PROMPT
    You are a task prioritization AI tasked with cleaning the formatting of and reprioritizing the following tasks: #{task_names.join(', ')}.
    Consider the ultimate objective of your team: #{OBJECTIVE}.
    Do not remove any tasks. Return the result as a numbered list, like:
    #. First task
    #. Second task
    Start the task list with number #{next_task_id}.
  PROMPT
  response = openai_call(prompt)
  new_tasks = response.split("\n") || [response]
  task_list = []
  new_tasks.each_with_index do |task_name, index|
    task_id = next_task_id + index
    task_list << { task_id: task_id, task_name: task_name }
  end
end

def execution_agent(objective, task)
  context = context_agent(query: objective, top_results_num: 5)
  prompt = <<~PROMPT
    You are an AI who performs one task based on the following objective: #{objective}.
    Take into account these previously completed tasks: #{context}.
    Your task: #{task[:task_name]}
    Response:
  PROMPT
  return openai_call(prompt, max_tokens: 2000)
end

def context_agent(query:, top_results_num:)
  query_embedding = get_ada_embedding(query)
  results = index.query(query_embedding, top_k: top_results_num, include_metadata: true, namespace: OBJECTIVE)
  sorted_results = results.matches.sort_by(&:score).reverse
  return sorted_results.map { |item| item.metadata["task"] }
end

first_task = {"task_id": 1, "task_name": INITIAL_TASK}

add_task(first_task)

# Main loop
task_id_counter = 1
while true
  if task_list.any?
    # Print the task list
    puts "\033[95m\033[1m" + "\n*****TASK LIST*****\n" + "\033[0m\033[0m"
    task_list.each do |t|
      puts "#{t["task_id"]}: #{t["task_name"]}"
    end

    # Step 1: Pull the first task
    task = task_list.shift
    puts "\033[92m\033[1m" + "\n*****NEXT TASK*****\n" + "\033[0m\033[0m"
    puts "#{task["task_id"]}: #{task["task_name"]}"

    # Send to execution function to complete the task based on the context
    result = execution_agent(OBJECTIVE, task["task_name"])
    this_task_id = task["task_id"].to_i
    puts "\033[93m\033[1m" + "\n*****TASK RESULT*****\n" + "\033[0m\033[0m"
    puts result

    # Step 2: Enrich result and store in Pinecone
    enriched_result = {
      "data": result
    }  # This is where you should enrich the result if needed
    result_id = "result_#{task['task_id']}"
    vector = get_ada_embedding(
      enriched_result["data"]
    )  # get vector of the actual result extracted from the dictionary
    index.upsert(
      [{id: result_id, data: vector, metadata: {"task": task["task_name"], "result": result}}],
      namespace: OBJECTIVE
    )

    # Step 3: Create new tasks and reprioritize task list
    new_tasks = task_creation_agent(
      OBJECTIVE,
      enriched_result,
      task["task_name"],
      task_list.map {|t| t["task_name"]},
    )

    new_tasks.each do |new_task|
      task_id_counter += 1
      new_task["task_id"] = task_id_counter
      add_task(new_task)
    end

    prioritization_agent(this_task_id)
  end

  sleep(1)  # Sleep before checking the task list again
end
