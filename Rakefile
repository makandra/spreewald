#!/usr/bin/env rake
require "bundler/gem_tasks"


task "update_readme" do
  require 'support/documentation_generator'
  readme = File.read('README.md')
  start_of_steps_section = readme =~ /^## Steps/
  length_of_steps_section = (readme[(start_of_steps_section+1)..-1] =~ /^##[^#]/) || readme.size - start_of_steps_section
  readme[start_of_steps_section, length_of_steps_section] = "## Steps\n\n" + DocumentationGenerator::StepDefinitionsDirectory.new('lib/spreewald').format
  File.open('README.md', 'w') { |f| f.write(readme) }
end
