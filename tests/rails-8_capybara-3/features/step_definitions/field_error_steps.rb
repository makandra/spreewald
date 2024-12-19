Then /^I set the custom field error class to "([^"]+)"$/ do |error_class|
  Spreewald.field_error_class = error_class
end

Then /^I set the custom error message xpath to "(.+)"$/ do |error_message_xpath|
  Spreewald.error_message_xpath_selector = error_message_xpath
end

After('@field_errors') do
  Spreewald.field_error_class = nil
  Spreewald.error_message_xpath_selector = nil
end
