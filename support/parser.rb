class Parser

  ANYTHINGS = %w[([^\"]*) ([^"]*) (.*) (.*?) [^"]+ ([^\"]+) ([^']*)
    ([^\/]*) (.+) (.*[^:]) .+? .+].map &Regexp.method(:escape)

  def self.human_regex(regex)
    regex.
      sub(/^\(?\/\^?/, ''). # Strip Regex beginning
      sub(/\$?\/\)?$/, ''). # Strip Regex end
      gsub(' ?', ' ').
      gsub('(?:|I )', 'I ').
      gsub('(?:', '(').
      gsub(Regexp.new(Regexp.escape '(\d+)(st|nd|rd|th)'), '<nth>').
      gsub(Regexp.new(ANYTHINGS.join '|'), '...').
      gsub(/\\\//, '/')
  end

  def self.format_comment(comment)
    comment.gsub! /.*coding:.*UTF-8.*/, ''
    comment.strip!
    comment_lines = comment.split("\n").take_while { |line| line =~ /^\s*#/ }
    comment_lines && comment_lines.join("\n").gsub(/^\s*# ?/, '')
  end

end
