# coding: UTF-8

# Marks scenario as pending
Then /^it should work$/ do
  pending
end.overridable

# See "Then console"
Then 'debugger' do
  step 'console'
end.overridable

# Pauses test execution and opens an IRB shell. Does not halt the application-
# under-test. (Replaces the "Then debugger" step that has never been adequate
# for its job.)
Then 'console' do
  require 'irb'
  ARGV.clear # IRB takes ARGV as its own arguments

  IRB.start
end.overridable

# Waits 2 seconds after each step
AfterStep('@slow-motion') do
  sleep 2
end

# Waits for keypress after each step
AfterStep('@single-step') do
  print "Single Stepping. Hit enter to continue"
  STDIN.getc
end
