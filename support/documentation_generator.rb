module DocumentationGenerator

  module CommentExtractor
    def parse_and_format_comment(comment)
      comment.gsub!(/.*coding:.*UTF-8.*/, '')
      comment.strip!
      comment_lines = comment.split("\n").take_while { |line| line =~ /^\s*#/ }
      comment_lines && comment_lines.join("\n").gsub(/^\s*# ?/, '')
    end
  end

  class StepDefinition

    extend CommentExtractor

    def initialize(definition, comment = nil)
      @definition = definition
      @comment = comment
    end

    def self.try_and_parse(code)
      definition = code[/^\s*((When|Then|Given|AfterStep).*)do/, 1]
      return unless definition
      comment = parse_and_format_comment(code)
      return if comment =~ /\bnodoc\b/
      new(definition.strip, comment)
    end

    def format
      <<-TEXT
* **#{format_definition}**

#{@comment.gsub(/^/, '  ')}
      TEXT
    end

    def format_definition
      if @definition =~ /AfterStep/
        @definition[/@\w*/]
      else
        capture_groups = %w[([^\"]*) ([^"]*) (.*) (.*?) [^"]+ ([^\"]+) ([^']*) ([^/]*) (.+) (.*[^:])]
        capture_groups.map! &Regexp.method(:escape)

        @definition.
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

  class StepDefinitionFile
    
    FILE_COMMENT_END = 'FILE_COMMENT_END'

    include CommentExtractor

    def initialize(filename)
      @filename = filename
      @code = File.read(filename)
      @steps = []
      extract_comment
      add_steps
    end

    def extract_comment
      if @code.include?(FILE_COMMENT_END)
        file_comment = @code.split(FILE_COMMENT_END).first
        @comment = parse_and_format_comment(file_comment)
      end
    end

    def add_steps
      @code.split("\n\n").each do |block|
        step = StepDefinition.try_and_parse(block)
        if step
          @steps << step
        end
      end
    end

    def format
      <<-TEXT
### #{format_filename}

#{@comment}

#{format_steps}
      TEXT
    end

    def format_filename
      @filename.split('/').last
    end

    def format_steps
      @steps.collect { |step| step.format }.join("\n\n")
    end
  end

  class StepDefinitionsDirectory
    def initialize(directory)
      @step_definition_files = []
      Dir["#{directory}/*.rb"].to_a.sort.each do |filename|
        next if filename =~ /all_steps/
        @step_definition_files << StepDefinitionFile.new(filename)
      end
    end

    def format
      @step_definition_files.collect { |step_definition_file| step_definition_file.format }.join("\n\n")
    end
  end

end
