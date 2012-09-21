Then /^it should work$/ do
  pending
end

Then /^debugger$/ do
  debugger
end

AfterStep('@slow-motion') do
  sleep 2
end

AfterStep('@single-step') do
  print "Single Stepping. Hit enter to continue"
  STDIN.getc
end
