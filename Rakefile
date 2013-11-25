#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Default: Run all tests.'
task :default => 'tests:run' # now you can run the tests by just typing "rake" into your console


desc 'Update the "Steps" section of the README'
task :update_readme do
  require 'support/documentation_generator'
  readme = File.read('README.md')
  start_of_steps_section = readme =~ /^## Steps/
  length_of_steps_section = (readme[(start_of_steps_section+1)..-1] =~ /^##[^#]/) || readme.size - start_of_steps_section
  readme[start_of_steps_section, length_of_steps_section] = "## Steps\n\n" + DocumentationGenerator::StepDefinitionsDirectory.new('lib/spreewald').format
  File.open('README.md', 'w') { |f| f.write(readme) }
end

namespace :travis do
  
  desc 'Run tests in Travis CI'
  task :run do
    Rake::Task['tests:create_database'].invoke
    Rake::Task['tests:bundle'].invoke
    Rake::Task['tests:run'].invoke
  end
end

namespace :tests do

  desc "Run tests on all test apps"
  task :run do # to run the tests type "rake tests:run" into your console
    success = true
    for_each_directory_of('tests/**/Rakefile') do |directory|
      Bundler.with_clean_env do
        env = "FEATURE=../../#{ENV['FEATURE']}" if ENV['FEATURE']
        success &= system("cd #{directory} && bundle exec rake features #{env}")
      end
    end
    fail "Tests failed" unless success
  end

  desc "Bundle all test apps"
  task :bundle do
    for_each_directory_of('tests/**/Gemfile') do |directory|
      Bundler.with_clean_env do
        system("cd #{directory} && bundle install")
      end
    end
  end

  desc 'Shortcut for creating a database'
  task :create_database do
    system("mysql -uroot -p -e 'create database spreewald_test;'")
  end

end

def for_each_directory_of(path, &block)
  Dir[path].sort.each do |rakefile|
    directory = File.dirname(rakefile)
    puts '', "\033[44m#{directory}\033[0m", ''
    block.call(directory)
  end
end
