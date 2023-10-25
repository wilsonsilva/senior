# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'tempfile'
require_relative 'google_search'

class ActionRunner
  def initialize(pastel, gpt)
    @pastel = pastel
    @gpt = gpt
  end

  def run(action)
    case action
    when ReadFileAction
      read_file(action.path)
    when WriteFileAction
      write_file(action.path, action.content)
    when RunRubyAction
      run_ruby(action.path)
    when SearchOnlineAction
      search_online(action.query)
    when ExtractInfoAction
      extract_info(action)
    else
      raise NotImplementedError, "Failed to run action: #{action}"
    end
  rescue StandardError => e
    puts pastel.red("Failed to complete the action: #{e}")
    "Error: #{e}"
  end

  private

  attr_reader :pastel, :gpt

  def read_file(path)
    unless File.exist?(path)
      puts("#{pastel.red("RESULT: ")}File `#{path}` does not exist.")
      return "File `#{path}` does not exist."
    end
    contents = File.read(path)
    puts("#{pastel.green("RESULT: ")}Read file `#{path}`.")
    contents
  end

  def write_file(path, content)
    File.write(path, content)
    puts("#{pastel.green("RESULT: ")}Wrote file `#{path}`.")

    'File successfully written.'
  end

  def run_ruby(path)
    output = `ruby #{path}`
    puts("#{pastel.green("RESULT: ")}Ran Ruby file `#{path}`.")
    output
  end

  def search_online(query)
    results = GoogleSeach.search(query)
    return "RESULT: The online search for `#{query}` appears to have failed." if results.empty?

    result = results.join("\n")
    puts("#{pastel.green("RESULT: ")}The online search for `#{query}` returned the following URLs:\n#{result}")
    result
  end

  def extract_info(action)
    spinner = TTY::Spinner.new('[:spinner] Reading website...', format: :arrow)
    spinner.spin
    html = get_html(url)
    text = extract_text(html)
    puts("#{pastel.green("RESULT: ")}The webpage at `#{action.url}` was read successfully.")
    user_message_content = "#{action.instructions}\n\n```\n#{text[0...10000]}\n```"
    messages = [
      {
        role: "system",
        content: "You are a helpful assistant. You will be given instructions to extract some information from the contents of a website. Do your best to follow the instructions and extract the info.",
      },
      { role: "user", content: user_message_content},
    ]
    request_token_count = gpt.count_tokens(messages)
    max_response_token_count = GPT::COMBINED_TOKEN_LIMIT - request_token_count

    spinner = TTY::Spinner.new('[:spinner] Extracting info...', format: :arrow)
    spinner.spin
    extracted_info = gpt.send_message(messages, max_response_token_count)
    puts("#{pastel.green("RESULT: ")}The info was extracted successfully.")
    spinner.stop
    extracted_info
  end

  def get_html(url)
    URI.open(url).read
  end

  def extract_text(html)
    soup = Nokogiri::HTML(html)
    soup.search('script, style').remove
    text = soup.text
    lines = text.lines.map(&:strip)
    chunks = lines.flat_map { |line| line.split(/\s{2,}/) }
    chunks.select(&:present?).join("\n")
  end
end
