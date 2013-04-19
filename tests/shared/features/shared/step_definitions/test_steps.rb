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
