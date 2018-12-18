#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'gemika/tasks'
rescue LoadError
  puts 'Run `gem install gemika` for additional tasks'
end

task :default => 'matrix:cucumber'

namespace :matrix do

  desc "Run Cucumber for all Ruby #{RUBY_VERSION} gemfiles"
  task :cucumber do
    Gemika::Matrix.from_travis_yml.each do |row|
      system("cd #{File.dirname row.gemfile} && BUNDLE_GEMFILE=Gemfile geordi cucumber")
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

  readme = File.read('README.md')
  start_of_steps_section = readme =~ /^## Steps/
  length_of_steps_section = (readme[(start_of_steps_section+1)..-1] =~ /^##[^#]/) || readme.size - start_of_steps_section
  readme[start_of_steps_section, length_of_steps_section] = "## Steps\n\n" + StepManager.new('lib/spreewald').to_markdown
  File.open(readme_path, 'w') { |f| f.write(readme) }

  system "git diff #{readme_path}"
  puts '', '> Done (diff applied).'
end



