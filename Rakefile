#!/usr/bin/env rake
require 'bundler/gem_tasks'

begin
  require 'gemika/tasks'
rescue LoadError
  puts 'Run `gem install gemika` for additional tasks'
end

task :default => 'matrix:tests'

namespace :matrix do
  desc 'Run tests for a single row of the matrix'
  task :single_test, [:gemfile, :ruby] do |_t, args|
    gemfile = args[:gemfile]
    ruby = args[:ruby]

    if gemfile.nil? || ruby.nil?
      warn 'Please state the Gemfile and Ruby version to be used for the Testrun!'
    else
      run_tests_for(gemfile, ruby)
    end
  end


  desc "Run all tests which are available for current Ruby (#{RUBY_VERSION})"
  task :tests, [:gemfile, :ruby] do |_t, args|
    Gemika::Matrix.from_ci_config.each do |row|
      run_tests_for(row.gemfile, row.ruby)
    end
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

def run_tests_for(gemfile, ruby)
  directory = File.dirname(gemfile)
  if directory.start_with?('tests')
    # Run integration tests (uses embedded projects)
    system(cucumber_command(directory, ruby))
  else
    # Run specs and integration tests for Spreewald binary
    [
      system("BUNDLE_GEMFILE=#{gemfile} bundle exec rspec"),
      system("BUNDLE_GEMFILE=#{gemfile} bundle exec cucumber"),
    ].all?
  end
end

def cucumber_command(directory, ruby_version)
  command = "cd #{directory} && BUNDLE_GEMFILE=Gemfile bundle exec cucumber"
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
