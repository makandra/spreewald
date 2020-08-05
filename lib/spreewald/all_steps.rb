# coding: UTF-8
require 'rspec/matchers'

ALREADY_LOADED_FILES = %w[all_steps timecop_steps]

Dir[File.join(File.dirname(__FILE__), '*_steps.rb')].each do |f|
  name = File.basename(f, '.rb')

  unless ALREADY_LOADED_FILES.include?(name)
    require "spreewald/#{name}"
  end
end
