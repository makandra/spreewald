#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Default: Run all tests.'
task :default => 'all:rubies'

desc 'Update the "Steps" section of the README'
task :update_readme do
  if Kernel.respond_to? :require_relative
    require_relative './support/step_manager'
  else
    require 'support/step_manager'
  end

  readme = File.read('README.md')
  start_of_steps_section = readme =~ /^## Steps/
  length_of_steps_section = (readme[(start_of_steps_section+1)..-1] =~ /^##[^#]/) || readme.size - start_of_steps_section
  readme[start_of_steps_section, length_of_steps_section] = "## Steps\n\n" + StepManager.new('lib/spreewald').to_markdown
  File.open('README.md', 'w') { |f| f.write(readme) }
end

namespace :all do

  desc 'Run tests on all test apps'
  task :features do
    success = true
    for_each_directory_of('tests/**/Rakefile') do |directory|
      success &= Bundler.clean_system("cd #{directory} && cuc")
    end
    fail "Tests failed" unless success
  end
  
  desc 'Install gems and run tests on several Ruby versions'
  task :rubies do
    success = case
    when system('which rvm')
      run_for_all_rubies :rvm
    when system('which rbenv') && `rbenv commands`.split("\n").include?('alias')
      # rbenv currently works only with the alias plugin, as we do not want to
      # specify Ruby versions down to their patch levels.
      run_for_all_rubies :rbenv
    else
      fail 'Currently only RVM and rbenv (with alias plugin) are supported. Open Rakefile and add your Ruby version manager!'
    end

    fail "Tests failed" unless success
  end

  desc 'Bundle all test apps'
  task :bundle do
    for_each_directory_of('tests/**/Gemfile') do |directory|
      Bundler.with_clean_env do
        system("cd #{directory} && bundle install && gem install geordi")
      end
    end
  end

end

def run_for_all_rubies(version_manager)
  %w[
    1.8.7
    1.9.3
    2.1.2
  ].all? do |ruby_version|
    announce "Running features for Ruby #{ruby_version}", 2

    execute = case version_manager
    when :rvm
      "rvm #{ruby_version} do"
    when :rbenv
      ENV['RBENV_VERSION'] = ruby_version
      'rbenv exec'
    end

    current_version = `#{execute} ruby -v`.match(/^ruby (\d\.\d\.\d)/)[1]
    if current_version == ruby_version
      puts "Currently active Ruby is #{current_version}"
      system "#{execute} rake all:bundle all:features"
    else
      fail "Failed to set Ruby #{ruby_version} (#{current_version} active!)"
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
      puts 'Capybara 2 requires Ruby 1.9 or greater'
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
