require 'cucumber/rspec/doubles'

RSPEC_EXPECTATION_NOT_MET_ERROR = RSpec::Expectations::ExpectationNotMetError

Then /^the following steps? should (fail|succeed):$/ do |expectation, steps_table|
  steps = steps_table.raw.flatten
  
  steps.each do |step|
    if expectation == 'fail'
      expect { step(step) }.to raise_error(RSPEC_EXPECTATION_NOT_MET_ERROR)
    
    else # succeed
      step(step)
    end

  end
end

When /^I run the following steps?:$/ do |steps_table|
  steps = steps_table.raw.flatten
  
  steps.each do |step|
    step(step)
  end
end

Then /^the following multiline step should (fail|succeed):$/ do |expectation, multiline_step|
  multiline_step = multiline_step.gsub(%{'''}, %{"""})
  if expectation == 'fail'
    expect { steps(multiline_step) }.to raise_error(RSPEC_EXPECTATION_NOT_MET_ERROR)
  else # succeed
    steps(multiline_step)
  end

end

Then(/^a hidden string with quotes should not be visible$/) do
  hidden_string = %Q{hidden '" quotes}
  assert_hidden(:text => hidden_string)
end

Then(/^a visible string with quotes should be visible$/) do
  visible_string = %Q{visible '" quotes}
  assert_visible(:text => visible_string)
end

Then(/^'show me the page' should open the page or take a screenshot$/) do
  # Projects with Capybara 1 & 2 use the launchy gem
  if Spreewald::Comparison.compare_versions(Capybara::VERSION, :<, "3.0")
    expect(Launchy).to receive(:open)
    step 'show me the page'
  else
    expect_any_instance_of(Capybara::Screenshot::Saver).to receive(:save)
    step 'show me the page'
  end
end
