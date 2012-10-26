#

# marks scenario as pending
Then /^it should work$/ do
  pending
end

Then /^debugger$/ do
  debugger
end

# waits 2 seconds after each step
AfterStep('@slow-motion') do
  sleep 2
end

# waits for keypress after each step
AfterStep('@single-step') do
  print "Single Stepping. Hit enter to continue"
  STDIN.getc
end
