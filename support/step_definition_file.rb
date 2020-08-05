require File.expand_path('../step_definition', __FILE__)
require File.expand_path('../parser', __FILE__)

class StepDefinitionFile

  FILE_COMMENT_END = 'FILE_COMMENT_END'

  attr_accessor :steps

  def initialize(filename)
    @filename = filename
    @code = File.read(filename)
    self.steps = []
    extract_comment
    add_steps
  end

  def to_markdown
    return '' if @comment =~ /\bnodoc\b/

    spaced_comment = "\n\n" + @comment if @comment

    <<-TEXT
### #{ @filename.split('/').last } #{spaced_comment}

#{ steps.collect(&:to_markdown).join("\n\n\n") }
    TEXT
  end

  def real_steps
    steps.select do |definition|
      StepManager::STEP_KINDS.include? definition.kind
    end
  end

private

  def extract_comment
    if @code.include?(FILE_COMMENT_END)
      file_comment = @code.split(FILE_COMMENT_END).first
      @comment = Parser.format_comment(file_comment)
    end
  end

  def add_steps
    @code.split("\n\n").each do |block|
      step = StepDefinition.new_from_raw(block)
      steps << step if step
    end
  end

end
