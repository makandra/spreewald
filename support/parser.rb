class Parser

  CAPTURE_GROUPS = %w[([^\"]*) ([^"]*) (.*) (.*?) [^"]+ ([^\"]+) ([^']*)
    ([^/]*) (.+) (.*[^:]) .+].map &Regexp.method(:escape)

  def self.human_regex(regex)
    regex.
      gsub('/^', '').
      gsub('$/', '').
      gsub(' ?', ' ').
      gsub('(?:|I )', 'I ').
      gsub('?:', '').
      gsub(Regexp.new(CAPTURE_GROUPS.join '|'), '...').
      gsub(/\\\//, '/')
  end

  def self.format_comment(comment)
    comment.gsub! /.*coding:.*UTF-8.*/, ''
    comment.strip!
    comment_lines = comment.split("\n").take_while { |line| line =~ /^\s*#/ }
    comment_lines && comment_lines.join("\n").gsub(/^\s*# ?/, '')
  end

end
