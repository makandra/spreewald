# coding: UTF-8
require 'rspec/matchers'

Dir[File.join(File.dirname(__FILE__), '*_steps.rb')].each do |f|
  name = File.basename(f, '.rb')
  unless name == 'all_steps'
    require "spreewald/#{name}"
  end
end
