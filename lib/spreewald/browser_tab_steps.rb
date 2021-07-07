Before do
  @previous_browser_tabs_count = nil
end

# Close all but the first browser tab
After do
  next unless selenium_driver?

  browser.switch_to.window(browser.window_handles.last)
  while browser.window_handles.size > 1 do
    browser.close
    browser.switch_to.window(browser.window_handles.last)
  end
end

# Opens [the page](https://github.com/makandra/spreewald/blob/master/examples/paths.rb) in a new browser tab and switches to it.
When /^I open (.+?) in a new browser tab$/ do |page_name|
  require_selenium!
  previous_handles_count = browser.window_handles.size
  relative_target_path = path_to(page_name)

  page.execute_script "window.open('#{relative_target_path}', '_blank', 'noopener')"
  step "there should be #{previous_handles_count + 1} browser tabs"
  step "I switch to the new browser tab"
end.overridable

# Closes the current browser tab and switches back to the first tab.
When 'I close the browser tab' do
  require_selenium!
  # Wait for browser tab to close
  previous_handles_count = browser.window_handles.size
  raise 'Cannot close the last remaining browser tab' if previous_handles_count == 1

  browser.close
  step "there should be #{previous_handles_count - 1} browser tabs"

  # Closing the current tab causes Selenium to continue using a stale invalid tab handle
  browser.switch_to.window(browser.window_handles.first)
end.overridable

# Waits for the new browser tab to appear, then switches to it.
When /^I switch to the new(?:ly opened)? browser tab$/ do
  require_selenium!
  step 'there should be at least 2 browser tabs'
  browser.switch_to.window(browser.window_handles.last)
end.overridable

# Changes the browser context to the second-last browser tab.
When /^I switch(?: back)? to the previous browser tab$/ do
  require_selenium!
  previous_handle = browser.window_handles[-2] # Second last should be the previous browser tab
  previous_handle ||= browser.window_handles.first # Fall back if only one tab is left
  browser.switch_to.window(previous_handle)
end.overridable

# Required for the check whether a new browser tab was opened or not.
When 'I may open a new browser tab' do
  @previous_browser_tabs_count = browser.window_handles.size
end.overridable

# Example (positive expectation):
#
#     When I may open a new browser tab
#       And I click on "Open link in new browser tab"
#     Then I should have opened a new browser tab
#
# Example (negative expectation):
#
#     When I may open a new browser tab
#       And I click on "Open link in current browser tab"
#     Then I should not have opened a new browser tab
Then /^I should( not)? have opened a new browser tab$/ do |negate|
  raise "you need to use the 'I may open a new tab' step beforehand" unless @previous_browser_tabs_count
  expected_browser_tab_count = negate ? @previous_browser_tabs_count : (@previous_browser_tabs_count + 1)

  step "there should be #{expected_browser_tab_count} browser tabs"
end.overridable

Then /^there should be (\d+) browser tabs?$/ do |expected_browser_tabs|
  patiently do
    actual_browser_tabs = browser.window_handles.size
    expect(actual_browser_tabs).to eq(expected_browser_tabs.to_i), "Expected #{expected_browser_tabs} browser tab to be open, but found #{actual_browser_tabs}"
  end
end.overridable

Then /^there should be at least (\d+) browser tabs?$/ do |expected_browser_tabs|
  patiently do
    actual_browser_tabs = browser.window_handles.size
    expect(actual_browser_tabs).to be >= (expected_browser_tabs.to_i), "Expected at least #{expected_browser_tabs} browser tab to be open, but found #{actual_browser_tabs}"
  end
end.overridable
