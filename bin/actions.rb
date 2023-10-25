# frozen_string_literal: true

class ReadFileAction
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def key
    'READ_FILE'
  end

  def short_string
    "Read file `#{@path}`."
  end
end

class WriteFileAction
  attr_reader :path, :content

  def initialize(path, content)
    @path = path
    @content = content
  end

  def key
    'WRITE_FILE'
  end

  def short_string
    "Write file `#{@path}`."
  end
end

class RunRubyAction
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def key
    'RUN_RUBY'
  end

  def short_string
    "Run Ruby file `#{@path}`."
  end
end

class SearchOnlineAction
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def key
    'SEARCH_ONLINE'
  end

  def short_string
    "Search online for `#{@query}`."
  end
end

class ExtractInfoAction
  attr_reader :url, :instructions

  def initialize(url, instructions)
    @url = url
    @instructions = instructions
  end

  def key
    'EXTRACT_INFO'
  end

  def short_string
    "Extract info from `#{@url}`: #{@instructions}."
  end
end

class ShutdownAction
  def key
    'SHUTDOWN'
  end

  def short_string
    'Shutdown.'
  end
end
