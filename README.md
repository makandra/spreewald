# Spreewald

Spreewald is a collection of useful steps for cucumber. Feel free to fork.

You can find a list of all contained steps at the end of this README.

## Supported versions

Spreewald is currently tested against and Ruby 2.6.6 and 3.0.0 with Rails 7 and Capybara 3.

## Installation

Add this line to your application's Gemfile:

    gem 'spreewald'

And then execute:

    $ bundle install

Require all Spreewald steps by putting

    require 'spreewald/all_steps'

into either your `support/env.rb` or `step_definitions/spreewald_steps.rb`.

Steps are grouped into a number of categories. If you only want to use a subset
of Spreewald's steps, instead of `require 'spreewald/all_steps'`, you can pick 
and choose single categories by requiring [single files](https://github.com/makandra/spreewald/tree/master/lib/spreewald) like this:

    require 'spreewald/email_steps'
    require 'spreewald/web_steps'

After that you are good to go and use the steps [described below](#steps).

### Recommended additional setup

We recommend using a `features/support/paths.rb` file in your project to define mappings between verbal phrases and your project's routes. You can then use these phrases in steps like `Then I should be on ...` or `When I go to ...`.
You can find [an example in this repository](https://github.com/makandra/spreewald/blob/master/examples/paths.rb). Please note that you may have to adapt it depending on the namespaces and other setup of your application's routes.

Similarly, you may define a `features/support/selectors.rb` file in your project to define mappings of verbal phrases to CSS selectors. You can also find [an example for that in this repository](https://github.com/makandra/spreewald/blob/master/examples/selectors.rb). These mappings can be used with steps like `Then I should( not)? see (an|the) element for ...` or `When I click on the element for ...`.

We also suggest to look at our [recommended Capybara defaults](#recommended-capybara-defaults) as they impact the behavior of many Spreewald steps.

## Spreewald binary

Spreewald comes with a binary that prints a list of all Cucumber steps from
Spreewald _and your project_. It will filter the list by any string you
pass it. Example usage (e.g. on a linux shell in the root folder of the project which uses Spreewald):

```bash
spreewald # lists all steps
spreewald mail # lists all steps that contain "mail"
```

The binary also prints paths and selectors; run `spreewald --help` to learn more.


## Waiting for page load

Spreewald's web steps are all aware that you might run them with a Selenium/Capybara webdriver, and wait for the browser to finish loading the page, if necessary.

This is done by rerunning any assertions until they succeed or a timeout is reached.

We consider a couple of potential exceptions as "retriable", including

    Capybara::ElementNotFound, (R)Spec::Expectations::ExpectationNotMetError, Capybara::Poltergeist::ClickFailed

You can add your own error class with

    ToleranceForSeleniumSyncIssues::RETRY_ERRORS << 'MyCustomError'

You can achieve this in your own steps by wrapping them inside a `patiently do` block, like

    Then /^I should see "([^\"]*)" in the HTML$/ do |text|
      patiently do
        page.body.should include(text)
      end
    end

More info [here](https://makandracards.com/makandra/12139-waiting-for-page-load-with-spreewald).


## Overriding steps

Thanks to [cucumber_priority](https://github.com/makandra/cucumber_priority) you can override any step definition from Spreewald with your own pattern. Cucumber will not raise `Cucumber::Ambiguous` if your custom steps collide with a Spreewald step.


## Recommended Capybara defaults

If you are upgrading from Capybara 2 to Capybara 3, you might [see failing tests](https://github.com/makandra/spreewald/issues/95) with Spreewald steps like `I should see`. This is caused by a breaking change in [Capybara's Finders](https://www.rubydoc.info/github/jnicklas/capybara/Capybara/Node/Finders) that accept a `:text` option. To activate Capybara 2 behavior globally in your project, enable this flag:

```ruby
Capybara.default_normalize_ws = true
````

This will affect all Spreewald steps that are using Capybara's `:text` option.

Furthermore, we recommend setting [Capybara's matching strategy](https://github.com/teamcapybara/capybara/blob/master/README.md#strategy) to `:prefer_exact`. This will positively affect Spreewald steps as it prevents the `Capybara::Ambiguous` error in the edge case when two fields are matching the given name, but one of the matches includes the name only as a substring.

```ruby
Capybara.match = :prefer_exact
````

If you want Spreewald to match fields, links and buttons against the `aria-label` attribute, enable the following global configuration in Capybara 2.8+: 

```ruby
Capybara.enable_aria_label = true
```

## Contributing

### Testing

[Gemika](https://github.com/makandra/gemika) is used to manage Gemfiles for different ruby versions.

Spreewald has different kind of tests:
- Unit tests live in `spec/`
- Test applications for integration tests with various Capybara versions live in `tests/`. 
- Tests for the Spreewald binary live in `features/`

Run all tests for your current ruby version with `rake` or `rake matrix:tests`. To bundle use `rake matrix:install` first.

### If you would like to contribute:

- Fork the repository
- Push your changes with specs
- Make sure `rake matrix:tests` passes
- Regenerate the "Steps" section of this Readme with `rake update_readme`, if needed
- Make a pull request


## This README

The "Steps" section is autogenerated by `rake update_readme` from comments in
the step definitions.


## Steps

### browser_tab_steps.rb 

* **When I open ... in a new browser tab**

  Opens [the page](https://github.com/makandra/spreewald/blob/master/examples/paths.rb) in a new browser tab and switches to it.


* **When I close the browser tab**

  Closes the current browser tab and switches back to the first tab.


* **When I switch to the new(ly opened)? browser tab**

  Waits for the new browser tab to appear, then switches to it.


* **When I switch( back)? to the previous browser tab**

  Changes the browser context to the second-last browser tab.


* **When I may open a new browser tab**

  Required for the check whether a new browser tab was opened or not.


* **Then I should( not)? have opened a new browser tab**

  Example (positive expectation):
  
      When I may open a new browser tab
        And I click on "Open link in new browser tab"
      Then I should have opened a new browser tab
  
  Example (negative expectation):
  
      When I may open a new browser tab
        And I click on "Open link in current browser tab"
      Then I should not have opened a new browser tab


* **Then there should be (\d+) browser tabs?**


* **Then there should be at least (\d+) browser tabs?**


### development_steps.rb 

* **Then it should work...?**

  Marks scenario as pending, optionally explained with a reason.


* **Then console**

  Pauses test execution and opens an IRB shell with current context. Does not halt the application-
  under-test.


* **AfterStep @slow-motion**

  Waits 2 seconds after each step


* **AfterStep @single-step**

  Waits for a keypress after each step


### email_steps.rb 

* **When I clear my e?mails**


* **Then (an?|no)( HTML| plain-text|) e?mail should have been sent with:**

  Example:
  
      Then an email should have been sent with:
        """
        From: max.mustermann@example.com
        Reply-To: mmuster@gmail.com
        To: john.doe@example.com
        CC: jane.doe@example.com
        BCC: johnny.doe@example.com
        Subject: The subject may contain "quotes"
        Attachments: image.jpg, attachment.pdf
  
        This is the message body. You can use * as a wildcard to omit the rest
        of a line *
        Or you can omit multiple lines if the asterisk is the only
        character in a single line, like this:
        *
  
        """
  
  You may skip lines in the header.
  Please note: In older versions of Spreewald, unmentioned body lines were skipped.
  Now you have to use the asterisk explicitly to omit lines in the body.


* **When I follow the (first|second|third)? link in the e?mail**

  Please note that this step will only follow HTTP and HTTPS links.
  Other links (such as mailto: or ftp:// links) are ignored.


* **Then no e?mail should have been sent**


* **Then I should see "..." in the( HTML| plain-text|) e?mail**

  Checks that the last sent email includes some text


* **Then show me the e?mail( header)?s**

  Print all sent emails to STDOUT (optionally only the headers).


* **Then show me the e?mail( header)?s with:**

  Print a subset of all sent emails to STDOUT
  This uses the same syntax as `Then an email should have been sent with:`


### frame_steps.rb 

* **When ... inside the ... iframe**

  You can append `inside the [name or number] iframe` to any other step.
  Then the step will operate inside the given iframe.
  Examples:
  
      Then I should see "Kiwi" inside the 1st iframe
      Then I should see "Cherry" inside the fruits iframe
      When I press "Save" inside the 2nd iframe



* **When I switch to the ... iframe**

  This step will switch to the iframe identified by its name or number.
  All further steps will operate inside the iframe.
  To switch to operating on the main page again, use the step
  "I switch back to the whole page".
  Examples:
  
      When I switch to the 1st iframe
      When I switch to the fruits iframe
  
  Please note: This step is only available for Capybara >= 3.


* **When I switch back to the whole page**

  This step can be used to switch back to the whole page if you switched
  to operating inside an iframe before (step `I switch to the ... iframe`).
  
  Please note: This step is only available for Capybara >= 3.


### session_steps.rb 

* **When ... in the browser session "..."**

  You can append `in the browser session "name"` to any other step to execute
  the step in a different browser session.
  
  You may need to update other steps to allow multiple sessions (e.g. your
  authentication steps have to support multiple logged in users).
  More details [here](https://makandracards.com/makandra/474480-how-to-make-a-cucumber-test-work-with-multiple-browser-sessions).


### table_steps.rb 

* **Then I should( not)? see a table with (exactly )?the following rows( in any order)?:?**

  Check the content of tables in your HTML.
  
  See [this article](https://makandracards.com/makandra/763-cucumber-step-to-match-table-rows-with-capybara) for details.


### time_steps.rb 

Steps to travel through time

This uses [Timecop](https://github.com/jtrupiano/timecop) or Active Support 4.1+ to stub Time.now / Time.current.
The user is responsible for including one of the two gems.

Please note that the two approaches branch. While ActiveSupport will freeze the time, Timecop will keep it running.


* **When the (date|time) is "?(\d{4}-\d{2}-\d{2}( \d{1,2}:\d{2})?)"?**

  Example:
  
      Given the date is 2012-02-10
      Given the time is 2012-02-10 13:40


* **When the time is "?(\d{1,2}:\d{2})"?**

  Example:
  
      Given the time is 13:40


* **When it is (\d+|an?|some|a few) (seconds?|minutes?|hours?|days?|weeks?|months?|years?) (later|earlier)**

  Example:
  
      When it is 10 minutes later
      When it is a few hours earlier


### web_steps.rb 

Most of cucumber-rails' original web steps plus a few of our own.

Note that cucumber-rails deprecated all its steps quite a while ago with the following
deprecation notice. Decide for yourself whether you want to use them:

> This file was generated by Cucumber-Rails and is only here to get you a head start
> These step definitions are thin wrappers around the Capybara/Webrat API that lets you
> visit pages, interact with widgets and make assertions about page content.

> If you use these step definitions as basis for your features you will quickly end up
> with features that are:

> * Hard to maintain
> * Verbose to read

> A much better approach is to write your own higher level step definitions, following
> the advice in the following blog posts:

> * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
> * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
> * http://elabs.se/blog/15-you-re-cuking-it-wrong



* **When ... within ...**

  You can append `within [selector]` to any other web step, even multiple times.
  Be aware that within will only look at the first element that matches.
  If this is a problem for you following links, you might want to have a look
  at the 'When I follow "..." inside any "..."'-step.
  
  Example:
  
      Then I should see "some text" within ".page_body"


* **Given I am on ...**


* **When I go to ...**


* **Then I should be on ...**


* **When I press "..."**


* **When I follow "..."**


* **When I fill in "..." (with|for) "..."**

  Fill in text field


* **When I fill in "..." (with|for):**

  Fill in text field with multi-line block
  You can use a doc string to supply multi-line text
  
  Example:
  
      When I fill in "some field" with:
      """
      Apple
      Banana
      Pear
      """


* **When I fill in "..." (with|for) '...'**

  Fill in text field


* **When I select "..." from "..."**

  Select from select box


* **When I check "..."**

  Check a checkbox


* **When I uncheck "..."**

  Uncheck a checkbox


* **When I choose "..."**

  Select a radio button


* **When I attach the file "..." to "..."**

  Attach a file to a file upload form field


* **Then I should( not)? see "..."**

  Checks that some text appears on the page
  
  Note that this does not detect if the text might be hidden via CSS


* **Then I should( not)? see /.../**

  Checks that a regexp appears on the page
  
  Note that this does not detect if the text might be hidden via CSS


* **Then I should( not)? see a field "..."**

  Checks for the existance of an input field (given its id or label)


* **Then I should( not)? see the (number|amount) ([\-\d,\.]+)( ...)?**

  Use this step to test for a number or money amount instead of a simple `Then I should see`
  
  Checks for an unexpected minus sign, correct decimal places etc.
  
  See [here](https://makandracards.com/makandra/1225-test-that-a-number-or-money-amount-is-shown-with-cucumber) for details


* **Then I should( not)? see '...'**

  Like `Then I should see`, but with single instead of double quotes. In case
  the expected string contains quotes as well.


* **Then I should( not)? see "..." in the HTML**

  Check that the raw HTML contains a string


* **Then I should see an error**

  Checks that status code is 400..599


* **Then I should( not)? see (an|the) element "..."**

  Check that an element with the given selector is present on the page.
  
  Example:
  
      Then I should see an element ".panel"
      Then I should see the element ".panel"
      Then I should not see an element ".sidebar"
      Then I should not see the element ".sidebar"


* **Then I should( not)? see (an|the) element for ...**

  Check that an element with the given [selector alias](https://github.com/makandra/spreewald/blob/master/examples/selectors.rb) is present on the page.
  
  Example:
  
      Then I should see an element for the panel
      Then I should see the element for the panel
      Then I should not see an element for the sidebar
      Then I should not see the element for the sidebar


* **Then I should see in this order:?**

  Checks that these strings are rendered in the given order in a single line or in multiple lines
  
  Example:
  
      Then I should see in this order:
        | Alpha Group |
        | Augsburg    |
        | Berlin      |
        | Beta Group  |


* **Then I should( not)? see a link labeled "..."**

  Checks that the page contains a link with a given text or title attribute.


* **Then the "..." field should( not)? contain "..."**

  Checks that an input field contains some value (allowing * as wildcard character)


* **Then the "..." field should( not)? contain:**

  Checks that a multiline textarea contains some value (allowing * as wildcard character)


* **Then I should see a form with the following values:**

  Checks that a list of label/value pairs are visible as control inputs.
  
  Example:
  
      Then I should see a form with the following values:
        | E-mail | foo@bar.com   |
        | Role   | Administrator |


* **Then the "..." field should have the error "..."**

  Checks that an input field was wrapped with a validation error


* **Then the "..." field should( not)? have an error**


* **Then the "..." checkbox should( not)? be checked?**


* **Then the radio button "..." should( not)? be (checked|selected)**


* **Then I should have the following query string:**

  Example:
  
      I should have the following query string:
        | locale        | de  |
        | currency_code | EUR |
  
  Succeeds when the URL contains the given `locale` and `currency_code` params


* **Then show me the page**

  Open the current Capybara page using the `launchy` or `capybara_screenshot` gem


* **Then I should get a response with content-type "..."**

  Checks `Content-Type` HTTP header


* **Then I should get a download with filename "..."**

  Checks `Content-Disposition` HTTP header
  
  Attention: Doesn't work with Selenium, see https://github.com/jnicklas/capybara#gotchas


* **Then "..." should( not)? be selected for "..."**

  Checks that a certain option is selected for a text field


* **Then nothing should be selected for "..."**


* **Then "..." should( not)? be an option for "..."**

  Checks for the presence of an option in a select


* **Then the window should be titled "..."**


* **When I reload the page**


* **Then (the tag )?"..." should be visible**

  Checks that an element is actually present and visible, also considering styles.
  Within a selenium test, the browser is asked whether the element is really visible
  In a non-selenium test, we only check for `.hidden`, `.invisible` or `style: display:none`
  
  More details [here](https://makandracards.com/makandra/1049-capybara-check-that-a-page-element-is-hidden-via-css)


* **Then (the tag )?"..." should be hidden**

  Checks that an element is actually present and hidden, also considering styles.
  Within a selenium test, the browser is asked whether the element is really hidden.
  In a non-selenium test, we only check for `.hidden`, `.invisible` or `style: display:none`


* **When I click on "..."**

  Click on some text that might not be a link.
  
  Example:
  
      When I click on "Collapse"



* **When I click on the element "..."**

  Click on an element with the given selector.
  
  Example:
  
      When I click on the element ".sidebar"



* **When I click on the element for ...**

  Click on the element with the given [selector alias](https://github.com/makandra/spreewald/blob/master/examples/selectors.rb).
  
  Example:
  
      When I click on the element for the sidebar


* **Then "..." should link to "..."**

  Use this step to check external links.
  
  Example:
  
      Then "Sponsor" should link to "http://makandra.com/"
  
  Don't forget the trailing slash. Otherwise you'll get the error
    expected: /http:\/\/makandra.com(\?[^\/]*)?$/
         got: "http://makandra.com/" (using =~)


* **When I follow "..." inside any "..."**

  Click a link within an element matching the given selector. Will try to be clever
  and disregard elements that don't contain a matching link.
  
  Example:
  
      When I follow "Read more" inside any ".text_snippet"


* **Then I should( not)? see "..." inside any "..."**


* **When I fill in "..." with "..." inside any "..."**


* **When I confirm the browser dialog**


* **When I cancel the browser dialog**


* **When I enter "..." into the browser dialog**


* **Then the "..." (field|button|checkbox|radio button) should( not)? be disabled**

  Tests that an input, button, checkbox or radio button with the given label is disabled.


* **Then the "..." field should( not)? be visible**

  Tests that a field with the given label is visible.


* **When I perform basic authentication as ".../..." and go to ...**

  Performs HTTP basic authentication with the given credentials and visits the given path.
  
  More details [here](https://makandracards.com/makandra/971-perform-http-basic-authentication-in-cucumber).


* **When I go back**

  Goes to the previously viewed page.


* **Then the "..." select should( not)? be sorted**

  Tests whether a select field is sorted. Uses Array#natural_sort, if defined;
  Array#sort else.
