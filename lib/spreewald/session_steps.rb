# You can append `in the browser session "name"` to any other step to execute
# the step in a different browser session.
#
# You may need to update other steps to allow multiple sessions (e.g. your
# authentication steps have to support multiple logged in users).
# More details [here](https://makandracards.com/makandra/474480-how-to-make-a-cucumber-test-work-with-multiple-browser-sessions).
When /^(.*) in the browser session "([^"]+)"$/ do |nested_step, session_name|
  Capybara.using_session(session_name) do
    step(nested_step)
  end
end.overridable

# nodoc
When /^(.*) in the browser session "([^"]+)":$/ do |nested_step, session_name, table_or_string|
  Capybara.using_session(session_name) do
    step("#{nested_step}:", table_or_string)
  end
end.overridable
