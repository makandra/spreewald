# coding: UTF-8

# Most of cucumber-rails' original web steps plus a few of our own.
#
# Note that cucumber-rails deprecated all its steps quite a while ago with the following
# deprecation notice. Decide for yourself whether you want to use them:
#
# > This file was generated by Cucumber-Rails and is only here to get you a head start
# > These step definitions are thin wrappers around the Capybara/Webrat API that lets you
# > visit pages, interact with widgets and make assertions about page content.
#
# > If you use these step definitions as basis for your features you will quickly end up
# > with features that are:
#
# > * Hard to maintain
# > * Verbose to read
#
# > A much better approach is to write your own higher level step definitions, following
# > the advice in the following blog posts:
#
# > * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# > * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# > * http://elabs.se/blog/15-you-re-cuking-it-wrong
#
# FILE_COMMENT_END

require 'spreewald_support/tolerance_for_selenium_sync_issues'
require 'spreewald_support/path_selector_fallbacks'
require 'spreewald_support/step_fallback'
require 'spreewald_support/custom_matchers'
require 'spreewald_support/web_steps_helpers'
require 'spreewald_support/driver_info'
require 'uri'
require 'cgi'


# You can append `within [selector]` to any other web step.
# Be aware that within will only look at the first element that matches.
# If this is a problem for you following links, you might want to have a look
# at the 'When I follow "..." inside any "..."'-step.
#
# Example:
#
#     Then I should see "some text" within ".page_body"
When /^(.*) within (.*[^:])$/ do |nested_step, parent|
  selector = _selector_for(parent)
  if selector.is_a?(String) || selector.is_a?(Array) # could also be a Capybara::Node::Element
    patiently do
      expect(page).to have_selector(*selector)
    end
  end
  patiently do
    with_scope(parent) { step(nested_step) }
  end
end.overridable(:priority => -1)

# nodoc
When /^(.*) within (.*[^:]):$/ do |nested_step, parent, table_or_string|
  patiently do
    with_scope(parent) { step("#{nested_step}:", table_or_string) }
  end
end.overridable(:priority => -1)

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit _path_to(page_name)
end.overridable

When /^(?:|I )go to (.+)$/ do |page_name|
  visit _path_to(page_name)
end.overridable

Then /^(?:|I )should be on (.+)$/ do |page_name|
  patiently do
    fragment = URI.parse(current_url).fragment
    fragment.sub!(/[#?].*/, '') if fragment # most js frameworks will usually use ? and # for params, we dont care about those
    current_path = URI.parse(current_url).path
    current_path << "##{fragment}" if fragment.present?
    expected_path = _path_to(page_name)

    # Consider two pages equal if they only differ by a trailing slash.
    current_path = expected_path if current_path.chomp("/") == expected_path.chomp("/")
    current_path = expected_path if current_path.gsub("/#", "#") == expected_path.gsub("/#", "#")

    expect(current_path).to eq(expected_path)
  end
end.overridable

When /^(?:|I )press "([^"]*)"$/ do |button|
  patiently do
    click_button(button)
  end
end.overridable

When /^(?:|I )follow "([^"]*)"$/ do |link|
  patiently do
    click_link(link)
  end
end.overridable

# Fill in text field
When /^(?:|I )fill in "([^"]*)" (?:with|for) "([^"]*)"$/ do |field, value|
  patiently do
    fill_in(field, :with => value)
  end
end.overridable

# Fill in text field with multi-line block
# You can use a doc string to supply multi-line text
#
# Example:
#
#     When I fill in "some field" with:
#     """
#     Apple
#     Banana
#     Pear
#     """
When /^(?:|I )fill in "([^"]*)" (?:with|for):$/ do |field, value|
  patiently do
    fill_in(field, :with => value)
  end
end.overridable

# Fill in text field
When /^(?:|I )fill in "([^"]*)" (?:with|for) '(.*)'$/ do |field, value|
  patiently do
    fill_in(field, :with => value)
  end
end.overridable

# Select from select box
When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  patiently do
    select(value, :from => field)
  end
end.overridable

# Check a checkbox
When /^(?:|I )check "([^"]*)"$/ do |field|
  patiently do
    check(field)
  end
end.overridable

# Uncheck a checkbox
When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  patiently do
    uncheck(field)
  end
end.overridable

# Select a radio button
When /^(?:|I )choose "([^"]*)"$/ do |field|
  patiently do
    choose(field)
  end
end.overridable

# Attach a file to a file upload form field
When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
  patiently do
    attach_file(field, File.expand_path(path))
  end
end.overridable

# Checks that some text appears on the page
#
# Note that this does not detect if the text might be hidden via CSS
Then /^(?:|I )should see "([^"]*)"$/ do |text|
  patiently do
    expect(page).to have_content(text)
  end
end.overridable

# Checks that a regexp appears on the page
#
# Note that this does not detect if the text might be hidden via CSS
Then /^(?:|I )should see \/(.*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  patiently do
    expect(page).to have_xpath('.//descendant-or-self::*', :text => regexp)
  end
end.overridable

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  patiently do
    expect(page).to have_no_content(text)
  end
end.overridable

Then /^(?:|I )should not see \/(.*)\/$/ do |regexp|
  patiently do
    regexp = Regexp.new(regexp)
    expect(page).to have_no_xpath('.//descendant-or-self::*', :text => regexp)
  end
end.overridable

# Checks for the existance of an input field (given its id or label)
Then /^I should( not)? see a field "([^"]*)"$/ do |negate, name|
  expectation = negate ? :not_to : :to
  patiently do
    begin
      # In old Capybaras find_field returns nil, so we assign it to `field`
      field = find_field(name)
    rescue Capybara::ElementNotFound
      # In Capybara 0.4+ #find_field raises an error instead of returning nil
      # We must explicitely reset the field variable from a previous patiently iteration
      field = nil
    end
    expect(field).send(expectation, be_present)
  end
end.overridable

# Use this step to test for a number or money amount instead of a simple `Then I should see`
#
# Checks for an unexpected minus sign, correct decimal places etc.
#
# See [here](https://makandracards.com/makandra/1225-test-that-a-number-or-money-amount-is-shown-with-cucumber) for details
Then /^I should( not)? see the (?:number|amount) ([\-\d,\.]+)(?: (.*?))?$/ do |negate, amount, unit|
  no_minus = amount.starts_with?('-') ? '' : '[^\\-]'
  nbsp = " "
  regexp = Regexp.new(no_minus + "\\b" + Regexp.quote(amount) + (unit ? "( |#{nbsp}|&nbsp;)(#{unit}|#{Regexp.quote(HTMLEntities.new.encode(unit, :named))})" :"\\b"))
  expectation = negate ? :not_to : :to
  patiently do
    expect(page.body).send(expectation, match(regexp))
  end
end.overridable

# Like `Then I should see`, but with single instead of double quotes. In case
# the expected string contains quotes as well.
Then /^(?:|I )should see '([^']*)'$/ do |text|
  patiently do
    expect(page).to have_content(text)
  end
end.overridable

# Check that the raw HTML contains a string
Then /^I should see "([^\"]*)" in the HTML$/ do |text|
  patiently do
    expect(page.body).to include(text)
  end
end.overridable

Then /^I should not see "([^\"]*)" in the HTML$/ do |text|
  patiently do
    expect(page.body).not_to include(text)
  end
end.overridable

# Checks that status code is 400..599
Then /^I should see an error$/ do
  expect((400 .. 599)).to include(page.status_code)
end.overridable

# Check that an element with the given selector is present on the page.
#
# Example:
#
#     Then I should see an element ".panel"
#     Then I should see the element ".panel"
#     Then I should not see an element ".sidebar"
#     Then I should not see the element ".sidebar"
Then /^I should (not )?see (?:an|the) element "([^"]+)"$/ do |negate, selector|
  expectation = negate ? :not_to : :to
  patiently do
    expect(page).send(expectation, have_css(selector))
  end
end.overridable

# Check that an element with the given [selector alias](https://github.com/makandra/spreewald/blob/master/examples/selectors.rb) is present on the page.
#
# Example:
#
#     Then I should see an element for the panel
#     Then I should see the element for the panel
#     Then I should not see an element for the sidebar
#     Then I should not see the element for the sidebar
Then /^I should (not )?see (?:an|the) element for (.*?)$/ do |negate, locator|
  expectation = negate ? :not_to : :to
  selector = _selector_for(locator)
  patiently do
    expect(page).send(expectation, have_selector(*selector))
  end
end.overridable(:priority => -5) # priority must be lower than the "within" step

# Checks that these strings are rendered in the given order in a single line or in multiple lines
#
# Example:
#
#     Then I should see in this order:
#       | Alpha Group |
#       | Augsburg    |
#       | Berlin      |
#       | Beta Group  |
Then /^I should see in this order:?$/ do |text|
  if text.is_a?(String)
    lines = text.split(/\n/)
  else
    lines = text.raw.flatten
  end
  lines = lines.collect { |line| line.gsub(/\s+/, ' ')}.collect(&:strip).reject(&:blank?)
  pattern = lines.collect(&Regexp.method(:quote)).join('.*?')
  pattern = Regexp.compile(pattern)
  patiently do
    expect(page.text.gsub(/\s+/, ' ')).to match(pattern)
  end
end.overridable

# Checks that the page contains a link with a given text or title attribute.
Then /^I should( not)? see a link labeled "([^"]*)"$/ do |negate, label|
  expectation = negate ? :not_to : :to
  link = page.first('a', :text => label, minimum: 0) || page.first(%(a[title="#{label}"]), minimum: 0)
  expect(link).send(expectation, be_present)
end

# Checks that an input field contains some value (allowing * as wildcard character)
Then /^the "([^"]*)" field should (not )?contain "([^"]*)"$/ do |label, negate, expected_string|
  patiently do
    field = find_field(label)
    field_value = case field.tag_name
    when 'select'
      options = field.all('option')
      selected_option = options.detect(&:selected?) || options.first
      if selected_option && selected_option.text.present?
        selected_option.text.strip
      else
        ''
      end
    else
      field.value
    end
    expect(field_value).send(negate ? :not_to : :to, contain_with_wildcards(expected_string))
  end
end.overridable

# Checks that a multiline textarea contains some value (allowing * as wildcard character)
Then(/^the "(.*?)" field should (not )?contain:$/) do |label, negate, expected_string|
  patiently do
    field = find_field(label)
    expect(field.value.chomp).send(negate ? :not_to : :to, contain_with_wildcards(expected_string))
  end
end.overridable

# Checks that a list of label/value pairs are visible as control inputs.
#
# Example:
#
#     Then I should see a form with the following values:
#       | E-mail | foo@bar.com   |
#       | Role   | Administrator |
Then /^I should see a form with the following values:$/ do |table|
  expectations = table.raw
  expectations.each do |label, expected_value|
    step %(the "#{label}" field should contain "#{expected_value}")
  end
end.overridable

# Checks that an input field was wrapped with a validation error
Then /^the "([^"]*)" field should have the error "([^"]*)"$/ do |field, error_message|
  patiently do
    element = find_field(field)
    classes = element.find(:xpath, '..')[:class].split(' ')

    form_for_input = element.find(:xpath, 'ancestor::form[1]')
    using_formtastic = form_for_input[:class].include?('formtastic')
    error_class = using_formtastic ? 'error' : 'field_with_errors'

    expect(classes).to include(error_class)

    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      error_paragraph.should have_content(error_message)
    else
      page.should have_content("#{field.titlecase} #{error_message}")
    end
  end
end.overridable

Then /^the "([^\"]*)" field should( not)? have an error$/ do |label, negate|
  patiently do
    expectation = negate ? :not_to : :to
    field = find_field(label)
    expect(field[:id]).to be_present # prevent bad CSS selector if field lacks id
    expect(page).send(expectation, have_css(".field_with_errors ##{field[:id]}"))
  end
end.overridable

Then /^the "([^"]*)" field should have no error$/ do |field|
  patiently do
    element = find_field(field)
    classes = element.find(:xpath, '..')[:class].split(' ')
    expect(classes).not_to include('field_with_errors')
    expect(classes).not_to include('error')
  end
end.overridable

Then /^the "([^"]*)" checkbox should( not)? be checked( and disabled)?$/ do |label, negate, disabled|
  expectation = negate ? :not_to : :to

  patiently do
    field = if Capybara::VERSION < "2.1"
      find_field(label)
    else
      find_field(label, :disabled => !!disabled)
    end
    expect(field).send expectation, be_checked
  end
end.overridable

Then /^the radio button "([^"]*)" should( not)? be (?:checked|selected)$/ do |field, negate|
  patiently do
    expect(page.send((negate ? :has_no_checked_field? : :has_checked_field?), field)).to eq(true)
  end
end.overridable

# Example:
#
#     I should have the following query string:
#       | locale        | de  |
#       | currency_code | EUR |
#
# Succeeds when the URL contains the given `locale` and `currency_code` params
Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  patiently do
    query = URI.parse(current_url).query
    actual_params = query ? CGI.parse(query) : {}
    expected_params = {}
    expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')}

    expect(actual_params).to eq(expected_params)
  end
end.overridable

# Open the current Capybara page using the `launchy` or `capybara_screenshot` gem
Then /^show me the page$/ do
  if defined? Launchy
    save_and_open_page
  elsif defined? Capybara::Screenshot
    screenshot_and_save_page
  else
    raise 'Neither launchy nor capybara_screenshot gem is installed. You have to add at least one of them to your Gemfile to use this step'
  end
end.overridable


# Checks `Content-Type` HTTP header
Then /^I should get a response with content-type "([^\"]*)"$/ do |expected_content_type|
  expect(page.response_headers['Content-Type']).to match /\A#{Regexp.quote(expected_content_type)}($|;)/
end.overridable

# Checks `Content-Disposition` HTTP header
#
# Attention: Doesn't work with Selenium, see https://github.com/jnicklas/capybara#gotchas
Then /^I should get a download with filename "([^\"]*)"$/ do |filename|
  expect(page.response_headers['Content-Disposition']).to match /filename="#{Regexp.escape(filename)}"$/
end.overridable

# Checks that a certain option is selected for a text field
Then /^"([^"]*)" should( not)? be selected for "([^"]*)"$/ do |value, invert, field|
  step %(the "#{field}" field should#{invert} contain "#{value}")
end.overridable

Then /^nothing should be selected for "([^"]*)"$/ do |field|
  patiently do
    select = find_field(field)
    begin
      selected_option = select.find(:xpath, ".//option[@selected = 'selected']") || select.all(:css, 'option').first
      value = selected_option ? selected_option.value : nil
      expect(value).to be_blank
    rescue Capybara::ElementNotFound
    end
  end
end.overridable

# Checks for the presence of an option in a select
Then /^"([^"]*)" should( not)? be an option for "([^"]*)"$/ do |value, negate, field|
  finder_arguments = if Capybara::VERSION < "2.12"
    ['option', { :text => value }]
  else
    ['option', { :exact_text => value }]
  end
  patiently do
    if negate
      begin
        expect(find_field(field)).to have_no_css(*finder_arguments)
      rescue Capybara::ElementNotFound
      end
    else
      expect(find_field(field)).to have_css(*finder_arguments)
    end
  end
end.overridable

Then /^the window should be titled "([^"]*)"$/ do |title|
  patiently do
    expect(pag).to have_css('title', :text => title)
  end
end.overridable

When /^I reload the page$/ do
  if javascript_capable?
    page.execute_script(<<-JAVASCRIPT)
        window.location.reload(true);
    JAVASCRIPT
  else
    visit current_path
  end
end.overridable

# Checks that an element is actually present and visible, also considering styles.
# Within a selenium test, the browser is asked whether the element is really visible
# In a non-selenium test, we only check for `.hidden`, `.invisible` or `style: display:none`
#
# The step 'Then (the tag )?"..." should **not** be visible' is ambiguous. Please use 'Then (the tag )?"..." should be hidden' or 'Then I should not see "..."' instead.
#
# More details [here](https://makandracards.com/makandra/1049-capybara-check-that-a-page-element-is-hidden-via-css)
Then /^(the tag )?"([^\"]+)" should( not)? be visible$/ do |tag, selector_or_text, hidden|
  if hidden
    warn "The step 'Then ... should not be visible' is prone to misunderstandings. Please use 'Then ... should be hidden' or 'Then I should not see ...' instead."
  end

  options = {}
  tag ? options.store(:selector, selector_or_text) : options.store(:text, selector_or_text)

  hidden ? assert_hidden(options) : assert_visible(options)
end.overridable

# Checks that an element is actually present and hidden, also considering styles.
# Within a selenium test, the browser is asked whether the element is really hidden.
# In a non-selenium test, we only check for `.hidden`, `.invisible` or `style: display:none`
Then /^(the tag )?"([^\"]+)" should be hidden$/ do |tag, selector_or_text|
  options = {}
  tag ? options.store(:selector, selector_or_text) : options.store(:text, selector_or_text)

  assert_hidden(options)
end.overridable

# Click on some text that might not be a link.
#
# Example:
#
#     When I click on "Collapse"
#
When /^I click on "([^\"]+)"$/ do |text|
  patiently do
    contains_text = %{contains(., \"#{text}\")}
    # find the innermost selector that matches
    element = page.find(:xpath, ".//*[#{contains_text} and not (./*[#{contains_text}])]")
    element.click
  end
end.overridable

# Click on an element with the given selector.
#
# Example:
#
#     When I click on the element ".sidebar"
#
When /^I click on the element "([^"]+)"$/ do |selector|
  patiently do
    page.find(selector).click
  end
end.overridable

# Click on the element with the given [selector alias](https://github.com/makandra/spreewald/blob/master/examples/selectors.rb).
#
# Example:
#
#     When I click on the element for the sidebar
When /^I click on the element for (.+?)$/ do |locator|
  patiently do
    selector = _selector_for(locator)
    page.find(*selector).click
  end
end.overridable(priority: -5) # priority lower than within

# Use this step to check external links.
#
# Example:
#
#     Then "Sponsor" should link to "http://makandra.com/"
#
# Don't forget the trailing slash. Otherwise you'll get the error 
#   expected: /http:\/\/makandra.com(\?[^\/]*)?$/
#        got: "http://makandra.com/" (using =~)
Then /^"([^"]*)" should link to "([^"]*)"$/ do |link_label, target|
  patiently do
    link = find_link(link_label)
    expect(link[:href]).to match(/#{Regexp.escape target}(\?[^\/]*)?$/) # ignore trailing timestamps
  end
end.overridable

# Checks that the result has content type `text/plain`
Then /^I should get a text response$/ do
  step 'I should get a response with content-type "text/plain"'
end.overridable

# Click a link within an element matching the given selector. Will try to be clever
# and disregard elements that don't contain a matching link.
#
# Example:
#
#     When I follow "Read more" inside any ".text_snippet"
When /^I follow "([^"]*)" inside any "([^"]*)"$/ do |label, selector|
  node = find("#{selector} a", :text => label)
  node.click
end.overridable

Then /^I should( not)? see "([^"]*)" inside any "([^"]*)"$/ do |negate, text, selector|
  expectation = negate ? :not_to : :to
  expect(page).send(expectation, have_css(selector, :text => text))
end.overridable

When /^I fill in "([^"]*)" with "([^"]*)" inside any "([^"]*)"$/ do |field, value, selector|
  containers = all(:css, selector)
  input = nil
  containers.detect do |container|
    input = container.first(:xpath, XPath::HTML.fillable_field(field))
  end
  if input
    input.set(value)
  else
    raise "Could not find an input field \"#{field}\" inside any \"#{selector}\""
  end
end.overridable

When /^I confirm the browser dialog$/ do
  patiently do
    page.driver.browser.switch_to.alert.accept
  end
end.overridable

When /^I cancel the browser dialog$/ do
  patiently do
    page.driver.browser.switch_to.alert.dismiss
  end
end.overridable

When /^I enter "([^"]*)" into the browser dialog$/ do |text|
  patiently do
    alert = page.driver.browser.switch_to.alert
    alert.send_keys(text)
    alert.accept
  end
end.overridable

When /^I switch to the new tab$/ do
  if javascript_capable?
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  else
    raise("This step works only with selenium")
  end
end.overridable

# Tests that an input or button with the given label is disabled.
Then /^the "([^\"]*)" (field|button|checkbox) should( not)? be disabled$/ do |label, kind, negate|
  if kind == 'field' || kind == 'checkbox'
    if Capybara::VERSION < "2.1"
      element = find_field(label, :disabled => !negate)
    else
      element = find_field(label, :disabled => !negate)
    end
  else
    element = find_button(label)
  end
  expect(["false", "", nil]).send(negate ? :not_to : :to, include(element[:disabled]))
end.overridable

# Tests that a field with the given label is visible.
Then /^the "([^\"]*)" field should( not)? be visible$/ do |label, hidden|
  if Capybara::VERSION < "2.1"
    field = find_field(label)
  else
    # Capybara 2.1+ won't usually interact with hidden elements,
    # but we can override this behavior by passing { visible: false }
    field = find_field(label, :visible => false)
  end

  selector = "##{field['id']}"

  if hidden
    assert_hidden(selector: selector)
  else
    assert_visible(selector: selector)
  end
end.overridable

# Waits for the page to finish loading and AJAX requests to finish.
#
# More details [here](https://makandracards.com/makandra/12139-waiting-for-page-loads-and-ajax-requests-to-finish-with-capybara).
When /^I wait for the page to load$/ do
  if javascript_capable?
    patiently do
      # when no jQuery is loaded, we assume there are no pending AJAX requests
      page.execute_script("return typeof jQuery === 'undefined' || $.active == 0;").should == true
    end
  end
  page.has_content? ''
end.overridable

# Performs HTTP basic authentication with the given credentials and visits the given path.
#
# More details [here](https://makandracards.com/makandra/971-perform-http-basic-authentication-in-cucumber).
When /^I perform basic authentication as "([^\"]*)\/([^\"]*)" and go to (.*)$/ do |user, password, page_name|
  path = _path_to(page_name)
  if javascript_capable?
    server = Capybara.current_session.server rescue Capybara.current_session.driver.rack_server
    visit("http://#{user}:#{password}@#{server.host}:#{server.port}#{path}")
  else
    authorizers = [
      (page.driver.browser if page.driver.respond_to?(:browser)),
      (self),
      (page.driver)
    ].compact
    authorizer = authorizers.detect { |authorizer| authorizer.respond_to?(:basic_authorize) }
    authorizer.basic_authorize(user, password)
    visit path
  end
end.overridable

# Goes to the previously viewed page.
When /^I go back$/ do
  if javascript_capable?
    page.execute_script('window.history.back()')
  else
    if page.driver.respond_to?(:browser)
      visit page.driver.browser.last_request.env['HTTP_REFERER']
    else
      visit page.driver.last_request.env['HTTP_REFERER']
    end
  end
end.overridable

# Tests whether a select field is sorted. Uses Array#natural_sort, if defined;
# Array#sort else.
Then /^the "(.*?)" select should( not)? be sorted$/ do |label, negate|
  select = find_field(label)
  options = select.all('option').reject { |o| o.value.blank? }
  option_texts = options.collect(&:text)

  expect(option_texts).send((negate ? :not_to : :to), be_sorted)
end.overridable
