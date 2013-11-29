# coding: UTF-8

require 'spreewald_support/tolerance_for_selenium_sync_issues'

#When /^I drag the item "([^"]*)" onto "([^"]*)"$/ do |movee_text, target_text|
#  patiently do
#    movee = page.find('ul.nodes li', :text => movee_text)
#    target = page.find('ul.nodes li', :text => target_text)
#    movee.drag_to(target) # <-- Capybara::Selenium.drag_to(target) does it with "mouse down, etc."
#  end
#end