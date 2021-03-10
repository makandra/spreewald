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

Then /^the step with an unsupported email header should raise:$/ do |step_string|
  multiline_step = step_string.gsub(%{'''}, %{"""})
  expect { steps(multiline_step) }.to raise_error(Spreewald::UnsupportedEmailHeader)
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
    expect_any_instance_of(Capybara::Screenshot::Saver).to receive(:save)
    step 'show me the page'
end
