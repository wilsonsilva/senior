# frozen_string_literal: true

require 'json'

class ResponseParser
  Metadata = Struct.new(:criticism, :reason, :plan, :speak, keyword_init: true)

  def self.parse(text)
    lines = text.split("\n")
    first_line = lines[0]

    case first_line
    when /^READ_FILE:/
      action = ReadFileAction.new(first_line[10..].strip)
      metadata = parse_metadata(lines[1..])
      [action, metadata]
    when /^WRITE_FILE:/
      path = lines[0][11..].strip

      raise ArgumentError, 'Not enough lines' if lines.length < 3
      raise ArgumentError, 'Incorrect delimiter' unless lines[1] == '```'

      line_index = 2
      content = ''
      lines[2..].each do |line|
        break if line == '```'

        line_index += 1
        content += "#{line}\n"
      end
      action = WriteFileAction.new(path, content)
      metadata = parse_metadata(lines[line_index + 1..])
      [action, metadata]
    when /^RUN_PYTHON:/
      action = RunRubyAction.new(first_line[11..].strip)
      metadata = parse_metadata(lines[1..])
      [action, metadata]
    when /^SEARCH_ONLINE:/
      action = SearchOnlineAction.new(first_line[14..].strip)
      metadata = parse_metadata(lines[1..])
      [action, metadata]
    when /^EXTRACT_INFO:/
      parts = first_line[13..].strip.split(',', 2)
      url = parts[0].strip.gsub('"', '')
      instructions = parts[1].strip
      action = ExtractInfoAction.new(url, instructions)
      metadata = parse_metadata(lines[1..])
      [action, metadata]
    when /^SHUTDOWN/
      action = ShutdownAction.new
      metadata = parse_metadata(lines[1..])
      [action, metadata]
    else
      raise NotImplementedError, "Failed to parse response: #{text}"
    end
  end

  def self.parse_metadata(lines)
    last_line_index = 1

    lines.each_with_index do |line, index|
      break if line.start_with?('}')

      last_line_index = index + 1
    end

    metadata_text = lines[0..last_line_index].join("\n").strip
    metadata_json = JSON.parse(metadata_text)

    Metadata.new(
      criticism: metadata_json['criticism'],
      reason: metadata_json['reason'],
      plan: metadata_json['plan'],
      speak: metadata_json['speak']
    )
  end
end
