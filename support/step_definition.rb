class StepDefinition

  attr_accessor :kind, :step, :comment

  def self.new_from_raw(raw_step)
    raw_step =~ /^\s*(When|Then|Given|AfterStep)(.*)do/
    kind, step = $1, $2
    return unless step

    comment = StepManager.parse_and_format_comment(raw_step)
    return if comment =~ /\bnodoc\b/

    new(kind, step, comment)
  end

  def initialize(kind, step, comment = nil)
    self.kind = kind
    self.step = step.strip
    self.comment = comment
  end

  def to_markdown
    <<-TEXT
* **#{ step }**

#{ comment.gsub /^/, '  ' }
    TEXT
  end

  def to_s
    "#{kind} #{pretty_step}"
  end

  private

  def pretty_step
    if kind == 'AfterStep'
      step[/@\w+/]
    else
      capture_groups = %w[([^\"]*) ([^"]*) (.*) (.*?) [^"]+ ([^\"]+) ([^']*) ([^/]*) (.+) (.*[^:])]
      capture_groups.map! &Regexp.method(:escape)

      step.
        gsub('/^', '').
        gsub('$/', '').
        gsub(' ?', ' ').
        gsub('(?:|I )', 'I ').
        gsub('?:', '').
        gsub(Regexp.new(capture_groups.join '|'), '...').
        gsub(/\\\//, '/')
    end
  end

end
