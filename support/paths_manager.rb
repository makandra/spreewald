require File.expand_path('../parser', __FILE__)

class PathsManager

  def initialize(file_path)
    @file_path = file_path
    read_paths
  end

  def paths(search = nil)
    paths = @raw_paths.map do |raw_path|
      path = raw_path.sub(/^\s+when/, '').strip

      if path.start_with? '/'
        Parser.human_regex(path)
      else
        path.gsub /\A["']|["']\z/, ''
      end
    end

    paths.reject do |path|
      if search
        path !~ Regexp.new(search)
      end
    end
  end

private

  def read_paths
    lines = File.readlines @file_path
    @raw_paths = lines.grep /^\s*when /
  end

end
