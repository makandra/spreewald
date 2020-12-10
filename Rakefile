#!/usr/bin/env rake
require 'bundler/gem_tasks'

begin
  require 'gemika/tasks'
rescue LoadError
  puts 'Run `gem install gemika` for additional tasks'
end

task :default => 'matrix:all_tests'

namespace :matrix do

  desc "Run all cucumber tests which are available for current Ruby (#{RUBY_VERSION})"
  task :cucumber_tests do
    # Run integration tests (uses embedded projects)
    command = "bundle exec cucumber"
    if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('2.5')
      # Modern cucumber sees pending tests as failures.
      # We don't want this.
      command << ' --no-strict-pending'
    end
    command

    system(command)
  end

  desc "Run all tests which are available for current Ruby (#{RUBY_VERSION})"
  task :all_tests do
    # Run specs and tests for spreewald binary
    system("bundle exec rspec")
    system("bundle exec cucumber")
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
