# coding: UTF-8

# Marks scenario as pending
Then /^it should work$/ do
  pending
end.overridable

# Starts debugger, or Pry if installed
Then /^debugger$/ do
  if binding.respond_to? :pry
    binding.pry
  else
    debugger
  end

  true # Ruby will halt in this line
end.overridable

# Pauses Cucumber, but not the application (unlike "Then debugger"). From the
# test browser, you can interact with your application as you like.
Then /^pause$/ do
  print 'Paused. Continue?'
  STDIN.getc
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
