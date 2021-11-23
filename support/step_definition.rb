require File.expand_path('../parser', __FILE__)

class StepDefinition

  attr_accessor :kind, :step, :comment

  def self.new_from_raw(raw_step)
    raw_step =~ /^\s*(When|Then|Given|AfterStep)(.*)do/
    kind, step = $1, $2
    return unless step

    comment = Parser.format_comment(raw_step)
    return if comment =~ /\bnodoc\b/

    new(kind, step, comment)
  end

  def initialize(kind, step, comment = nil)
    self.kind = kind
    self.step = step.strip
    self.comment = comment
  end

  def to_markdown
    spaced_comment = if comment
      "\n\n" + comment.gsub(/^/, '  ')
    end

    %(* **#{kind} #{pretty_step}**#{spaced_comment})
  end

  def to_s
    "#{kind} #{pretty_step}"
  end

  def matches_search?(search)
    regexp = Regexp.new(search)
    step =~ regexp || matches_without_optional_negation?(regexp)
  end

  private

  def pretty_step
    if kind == 'AfterStep'
      step[/@[\w-]+/]
    elsif step =~ /^'(.*)'$/ # Surrounded by single quotes
      $1
    else
      Parser.human_regex(step)
    end
  end

  def matches_without_optional_negation?(regexp)
    without_negation = step.gsub('( not)?', '').gsub('(not )?', '')
    with_negation = step.gsub('( not)?', ' not').gsub('(not )?', 'not ')
    with_negation =~ regexp || without_negation =~ regexp
  end

end
