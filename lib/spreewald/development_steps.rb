# coding: UTF-8

# Marks scenario as pending, optionally explained with a reason.
Then /^it should work(.+?)?$/ do |message|
  pending(message)
end.overridable

# Pauses test execution and opens an IRB shell with current context. Does not halt the application-
# under-test.
Then 'console' do
  require 'irb'
  ARGV.clear # IRB takes ARGV as its own arguments

  # We adapted the steps of IRB.run
  # https://github.com/ruby/ruby/blob/c08f7b80889b531865e74bc5f573df8fa27f2088/lib/irb.rb#L418
  # with injected workspace. See https://github.com/makandra/spreewald/issues/77 for reasons.

  # Don't setup IRB twice to avoid wall of
  # "already initialized constant" warnings
  unless IRB.conf[:LOAD_MODULES]
    IRB.setup(nil)

    # `source` is defined by Capybara as a shortcut to `page.source`. IRB tries to
    # create an alias with the same name and fails with a warning. To avoid this,
    # we remove the alias here.
    undef :source
  end

  workspace = IRB::WorkSpace.new(binding)
  irb = IRB::Irb.new(workspace)
  irb.context.prompt_mode = :SIMPLE

  IRB.conf[:MAIN_CONTEXT] = irb.context

  trap("SIGINT") do
    irb.signal_handle
  end

  begin
    catch(:IRB_EXIT) do
      irb.eval_input
    end
  ensure
    IRB.conf[:AT_EXIT].each{ |hook| hook.call }
  end
end.overridable

# Waits 2 seconds after each step
AfterStep('@slow-motion') do
  sleep 2
end

# Waits for a keypress after each step
AfterStep('@single-step') do
  print "Single Stepping. Hit enter to continue"
  STDIN.getc
end
