#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Default: Run all tests.'
task :default => 'all:rubies'

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

namespace :all do

  desc 'Run tests on all test apps'
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
  
  desc 'Run tests on several Ruby versions'
  task :rubies do
    rubies = %w[1.8.7 1.9.3 2.0.0]
    success = true

    if system('rvm -v 2>&1 > /dev/null') # rvm installed
      rubies.each do |ruby|
        announce 'Running features for Ruby ' + ruby, 2
        success &= system "rvm #{ruby} do rake all:bundle all:features"
      end
    else
      fail 'Currently only rvm is supported. Open Rakefile and add your Ruby version manager!'
    end
    
    fail "Tests failed" unless success
  end

  desc 'Bundle all test apps'
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
    announce directory
    
    if directory.include?('rails-2.3') and RUBY_VERSION != '1.8.7'
      puts 'Rails 2.3 tests are only run for Ruby 1.8.7'
    elsif directory.include?('capybara-2') and RUBY_VERSION == '1.8.7'
      puts 'Capybara requires Ruby 1.9 or greater'
    else
      block.call(directory)
    end
  end
end

def announce(text, level = 1)
  space = "\n" * level
  message = "# #{text}"
  puts "\e[4;34m#{space + message}\e[0m" # blue underline
end
