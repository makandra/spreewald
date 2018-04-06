# coding: UTF-8

# Marks scenario as pending
Then /^it should work$/ do
  pending
end.overridable

# nodoc
Then 'debugger' do
  step 'console' # Alias
end.overridable

# Pauses test execution and opens an IRB shell with current context. Does not halt the application-
# under-test. (Replaces the "Then debugger" step that has never been adequate
# for its job)
Then 'console' do
  require 'irb'
  ARGV.clear # IRB takes ARGV as its own arguments

  # We adapted the steps of IRB.run
  # https://github.com/ruby/ruby/blob/c08f7b80889b531865e74bc5f573df8fa27f2088/lib/irb.rb#L418
  # with injected workspace. See https://github.com/makandra/spreewald/issues/77 for reasons.

  IRB.setup(nil)

  workspace = IRB::WorkSpace.new(binding)
  irb = IRB::Irb.new(workspace)

  IRB.conf[:MAIN_CONTEXT] = irb.context

  trap("SIGINT") do
    irb.signal_handle
  end

  begin
    catch(:IRB_EXIT) do
      irb.eval_input
    end
  ensure
    IRB.irb_at_exit
  end
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
