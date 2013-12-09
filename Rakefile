#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Default: Run all tests.'
task :default => 'all:features'

desc 'Update the "Steps" section of the README'
task :update_readme do
  if Kernel.respond_to? :require_relative
    require_relative './support/documentation_generator'
  else
    require 'support/documentation_generator'
  end

  readme = File.read('README.md')
  start_of_steps_section = readme =~ /^## Steps/
  length_of_steps_section = (readme[(start_of_steps_section+1)..-1] =~ /^##[^#]/) || readme.size - start_of_steps_section
  readme[start_of_steps_section, length_of_steps_section] = "## Steps\n\n" + DocumentationGenerator::StepDefinitionsDirectory.new('lib/spreewald').format
  File.open('README.md', 'w') { |f| f.write(readme) }
end

namespace :travis do
  
  desc 'Run tests in Travis CI'
  task :run => [:slimgems, 'all:bundle', 'all:features']
  
  desc 'Install slimgems'
  task :slimgems do
    system('gem install slimgems')
  end
end

namespace :all do

  desc "Run tests on all test apps"
  task :features do
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
end

def for_each_directory_of(path, &block)
  Dir[path].sort.each do |rakefile|
    directory = File.dirname(rakefile)
    puts '', "\033[44m#{directory}\033[0m", ''

    if RUBY_VERSION.start_with?("1.9") and directory.include?("rails-2.3")
      puts 'Skipping Rails 2.3 with Ruby 1.9.'
    else
      block.call(directory)
    end
  end
end
