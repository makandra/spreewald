require File.expand_path('../step_definition_file', __FILE__)

class StepManager
  STEP_KINDS = %w[Given When Then]

  attr_accessor :directories, :step_files

  def initialize(*directories)
    self.directories = directories
    self.step_files = directories.map(&method(:collect_files)).flatten.compact
  end

  def to_markdown
    step_files.collect(&:to_markdown).join "\n\n"
  end

  def steps(search = nil)
    step_files.collect(&:real_steps).flatten.
      sort_by { |step| [STEP_KINDS.index(step.kind), step.to_s.downcase] }.
      reject do |definition|
        if search
          definition.step !~ Regexp.new(search)
        end
      end
  end

private

  def collect_files(directory)
    Dir["#{directory}/**/*_steps.rb"].to_a.sort.map do |filename|
      next if filename.include? 'spreewald/all_steps'
      StepDefinitionFile.new(filename)
    end.compact
  end

end
