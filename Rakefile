#!/usr/bin/env rake
require 'bundler/gem_tasks'

begin
  require 'gemika/tasks'
rescue LoadError
  puts 'Run `gem install gemika` for additional tasks'
end

task :default => 'matrix:tests'

task :spec do
  success = system("bundle exec rspec spec")
  fail "Tests failed" unless success
end

namespace :matrix do

  desc "Run all tests which are available for current Ruby (#{RUBY_VERSION})"
  task :tests do
    Gemika::Matrix.from_travis_yml.each do |row|
      directory = File.dirname(row.gemfile)
      if directory.start_with?('tests')
        # Run integration tests (uses embedded projects)
        system(cucumber_command(directory, row.ruby))
      else
        # Run specs and tests for spreewald binary
        [
          system("BUNDLE_GEMFILE=#{row.gemfile} bundle exec rspec"),
          system("BUNDLE_GEMFILE=#{row.gemfile} bundle exec cucumber"),
        ].all?
      end
    end

    travis_yml = YAML.load_file('.travis.yml')
    rubies = travis_yml.fetch('rvm') - [RUBY_VERSION]
    puts "Please remember to run tests for the other ruby versions as well: #{rubies.join(", ")}"
  end

end


desc 'Update the "Steps" section of the README'
task :update_readme do
  readme_path = 'README.md'
  if Kernel.respond_to? :require_relative
    require_relative './support/step_manager'
  else
    require 'support/step_manager'
  end

  readme = File.read(readme_path)
  File.open(readme_path, 'w') do |file|
    start_of_steps_section = readme =~ /^## Steps/
    length_of_steps_section = readme[(start_of_steps_section+1)..-1] =~ /^##[^#]/
    length_of_steps_section ||= readme.size - start_of_steps_section
    step_documentation = StepManager.new('lib/spreewald').to_markdown
    readme[start_of_steps_section, length_of_steps_section] = "## Steps\n\n#{step_documentation}"

    file.write(readme)
  end

  system "git diff #{readme_path}"
  puts '', '> Done (diff applied).'
end

def cucumber_command(directory, ruby_version)
  command = "cd #{directory} && BUNDLE_GEMFILE=Gemfile geordi cucumber"
  if Gem::Version.new(ruby_version) > Gem::Version.new('2.5')
    # Modern cucumber sees pending tests as failures.
    # We don't want this.
    command << ' --no-strict-pending'
  end
  command
end

def warn(text)
  puts "\e[31m#{text}\e[0m" # red text
end
