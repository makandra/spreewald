Transform /^(.*?) \((\d+) times\)$/ do |string, times|
  if string.is_a?(String)
    string * times.to_i
  else
    string
  end
end

Transform /^file:(.*)$/ do |path|
  File.open(path)
end

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
