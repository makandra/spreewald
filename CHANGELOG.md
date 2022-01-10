# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 4.3.5
- Fix deprecation warning for using keyword arguments as last argument when running with ruby 2.7

## 4.3.4
- Fix "undefined method `build_rb_world_factory` for nil:NilClass" error when running tests on a real project'
  - The field error class couldn't be required in certain circumstances and so the specs failed

## 4.3.3
- Fixes that the `Spreewald.field_error_class` configuration
did not find the correct elements

## 4.3.2
- Added built-in support for Rails and Bootstrap (3-5) error classes to the steps
  - `The ... field should have the error ...`
  - `The ... field should have an error`
- Added the possibility to specify custom error classes and message selectors for these steps
  using `Spreewald.field_error_class` and `Spreewald.error_message_xpath_selector` in your configuration.

- We had separate steps for e.g. `I should see ...` and `I should not see ...`. These were merged now:
  - `I should see "..."` + `I should not see "..."` => `I should( not)? see "..."`
  - `I should see /.../` + `I should not see /.../` => `I should( not)? see /.../`
  - `I should see '...'` + `I should not see '...'` => `I should( not)? see '...'`
- Optional negation was made more consistent. The steps use `"( not)? "` now.
- The search via `spreewald some query here` includes steps with optional negation now.

## 4.2.2
- Fixes the "Show me the email" step (#171)
- Fixes the "I follow the link in the email" step. (#172, #173)
  - It works for emails with and without explicit html parts
  - There's a better error message if no links are found

## 4.1.2
- Multiple invocations of console don't raise anymore

## 4.1.1
- The step `I open .. in a new browser tab` is now using the `noopener` option (see issue [#174])

## 4.1.0

- New steps:
  - When ... inside the ... iframe

- New steps only available for Capybara 3+:
  - When I switch to the ... iframe
  - When I switch back to the whole page
  - The I switch back to the whole page step does not work reliably with Capybara 2 and lead to StaleReferenceErrors, therefore we decided to not make these steps available for Capybara 2.

- Small improvements:
  - Trying to match against unsupported email headers will raise an error. Supported headers are "To", "CC", "BCC", "From", "Reply-To", "Subject", "Attachments"
  - It's now possible to have indented header lines in email steps.
  - If there's not an explicit text part in a mail, Spreewald determines if the email body is HTML or plaintext and converts it to plaintext accordingly.

## 4.0.0

- Dropped support for capybara 1, Ruby 2.1 and Rails 3.2. 

## 3.0.3

- The `an email should have been sent with` step now interprets all lines as body when not specifying headers (see issue [#157](https://github.com/makandra/spreewald/issues/157))

## 3.0.2

- Introduce wildcard for the beginning of a line. (see issue [#155](https://github.com/makandra/spreewald/issues/155))
  - This will allow you to check for a specific sentence inside the body

## 3.0.1

- Fix deduplication of linebreaks for html mails in mail finder. (see issue [#153](https://github.com/makandra/spreewald/issues/153))

## 3.0.0

### Breaking changes

- The following steps have been removed:
  - `/^the file "([^"]*)" was attached(?: as (?:([^"]*)\/)?([^"]*))? to the ([^"]*) above(?: at "([^"]*)")?$/` (see [#106](https://github.com/makandra/spreewald/issues/106), this functionality was moved to [CucumberFactory](https://github.com/makandra/cucumber_factory))
  - `/^the "([^"]*)" field should have no error$/` (see [#134](https://github.com/makandra/spreewald/issues/134))
  - `/^I should get a text response$/` (see [#135](https://github.com/makandra/spreewald/issues/135))
  - `/^I wait for the page to load$/` (see [#136](https://github.com/makandra/spreewald/issues/136))
  - `debugger` (was an alias for `console`)
- These email steps have been removed in favor of `(an?|no)( HTML| plain-text|) e?mail should have been sent with:` (see [#132](https://github.com/makandra/spreewald/issues/132#issuecomment-631457290)):
  - `/^(an|no) e?mail should have been sent((?: |and|with|from "[^"]+"|bcc "[^"]+"|cc "[^"]+"|to "[^"]+"|the subject "[^"]+"|the body "[^"]+"|the attachments "[^"]+")+)$/`
  - `/^that e?mail should( not)? have the following lines in the body$/`
  - `/^that e?mail should have the following (?:|content in the )body:$/`
- The `and disabled` modifier of the step `the "..." checkbox should( not)? be checked` has been removed. Use the step without the modifier together with the step `the "..." checkbox should be disabled` to achieve the old behavior.
- The step `/^(the tag )?"([^\"]+)" should( not)? be visible$/` lost its `not` modifier (Use `Then (the tag )?"..." should be hidden` or `Then I should not see "..."`)
- The file `lib/spreewald/timecop_steps.rb` was removed (was an alias for `lib/spreewald/time_steps.rb`).
- The step `(an?|no)( HTML| plain-text|) e?mail should have been sent with:` does now require that the whole body is matched.
- All web steps interacting with forms will now find both enabled and disabled fields. We encourage you to assert the "disabled" state in a separate step when needed, Spreewald offers these steps as well.

  The following steps have been adjusted:
  - `I should( not)? see a field "..."`
  - `the "..." field should( not)? contain "..."`
  - `I should see a form with the following values:`
  - `the "..." field should have the error "..."`
  - `the "..." field should( not)? have an error`
  - `the "..." checkbox should( not)? be checked`
  - `"..." should be selected for "..."`
  - `nothing should be selected for "..."`
  - `"..." should( not)? be an option for "..."`
  - `the "..." field should( not)? be visible`
  - `the "..." select should( not)? be sorted`
  
### Compatible changes
- Reintroduced support for emails with CRLF line ending

## 2.99.0
- The following steps were deprecated and will be removed in the upcoming major version:
  - `/^the "([^"]*)" field should have no error$/` (see [#134](https://github.com/makandra/spreewald/issues/134))
  - `/^I should get a text response$/` (see [#135](https://github.com/makandra/spreewald/issues/135))
  - `/^I wait for the page to load$/` (see [#136](https://github.com/makandra/spreewald/issues/136))
- The step `and disabled` modifier of the step `/^the "([^"]*)" checkbox should( not)? be checked( and disabled)?$/` has been deprecated.

## 2.9.0
- The step `an email should have been sent with:` does now support wildcards (`*` at the end of a line to ignore the rest of the line, `*` as single character in a line to ignore multiple lines). The step also has better error messages if an email could not be found.
- The step `show me the emails` got an option to display only the email headers. Additionally, a new step `show me the email( header)?s with:` has been created to only show a subset of all sent emails, with a syntax similar to `an email should have been sent with:`.
- The email steps `an email should have been sent (from ...) (to ...) (cc ...) ...`, `that email should( not)? have the following lines in the body` and `that email should have the following content in the body:` have been deprecated in favor of `an email should have been sent with:`.

## 2.8.0
- Add radio buttons to the `the "..." (field|button|checkbox|radio button) should( not)? be disabled` step.

## 2.7.2
- Fix the step `I follow the ... link in the email` if the email contains non-HTTP(S) links

## 2.7.1
- Support RFC-compliant encoding of filenames in `Content-Disposition` header (e.g. send_data), as provided by Rails 6.

## 2.7.0
- Add a step modifier to control different Capybara sessions: `... in the browser session "..."`. (see issue [#66](https://github.com/makandra/spreewald/issues/66))

## 2.6.0
- The time steps do now work with the time helpers in ActiveSupport 4.1+ if the timecop gem is not included in the bundle. Please note that the two approaches branch. While ActiveSupport will freeze the time, Timecop will keep it running.
- The steps in the file `spreewald/timecop.rb` file were moved to `spreewald/time.rb` and importing `spreewald/timecop` directly is deprecated now.

## 2.5.0
- Add a set of steps to control browser tabs (Selenium only):
  * `I open ... in a new browser tab`
  * `I close the browser tab`
  * `I switch to the new browser tab`
  * `I switch to the previous browser tab`
  * `I may open a new browser tab` (required for the following step)
  * `I should( not)? have opened a new browser tab`
  * `there should be (\d+) browser tabs?`
  * `there should be at least (\d+) browser tabs?`

## 2.4.2
- Fix the step `I should( not)? see a link labeled "STRING"`, it is now overridable.

## 2.4.1

- Adapt `I should get a download with filename "..."` step to also work if the `filename` is not the last attribute in `Content-Disposition` header.

## 2.4.0

- Fix "I follow the ... link in the email" step for HTML e-mails to only follow URLs from `<a href="...">` links.

## 2.3.0
- Deprecate two steps:
  - (Given) the file ... was attached to the ... above
  - (Then) debugger

## 2.2.4
- Fix "..." field should have the error "..." test by removing old should syntax
- Add single-line mail step to README

## 2.2.3
- Fix 'the window should be titled' step - closes: [#102](https://github.com/makandra/spreewald/issues/102)
- Support old capybara_screenshot versions which require launchy gem

## 2.2.2
- Fix `Then the "something" button should be disabled` (see issue [#18](https://github.com/makandra/spreewald/issues/18))
- Improve documentation of emails steps
- Clarify step definition of `that e?mail should have the following (?:|content in the )body:`

## 2.2.1
- Refactor the `I should see the (number|amount)` step. (see issues [#43](https://github.com/makandra/spreewald/issues/43) and [#44](https://github.com/makandra/spreewald/issues/44))
    * It can now be composed with the 'within' step
    * It can now truly match negative numbers
    * It dropped the hidden dependency on the HTMLEntities gem
* Fix URLs to the GitHub repository of Spreewald as part of the `_path_to` and `_selector_for` error handling. (see issue [#82](https://github.com/makandra/spreewald/issues/82))

## 2.2.0
- Add a new step `I should( not)? see a link labeled "STRING"`.
- Refer to Capybara 3's new flag `Capybara.default_normalize_ws = true` in the README,

## 2.1.3
The `I should(not )? see /REGEXP/` step no longer refuses slashes as part of the regular expression. You can thus match full domains and more.

## 2.1.2
Allow `I should(not )? see /REGEXP/` to be composed with the `within` step.

## 2.1.1
Fix `Then I should get a download with filename "..."' step

## 2.1.0
'Then show me the page' supports capybara-screenshot. (see [issue #81](https://github.com/makandra/spreewald/issues/81))

## 2.0.0
Mail steps supports both LF and CRLF linebreaks. (see [issue #83](https://github.com/makandra/spreewald/issues/83))
### Breaking Changes
Requires RSpec >= 2.13.0 because we dropped RSpec's should syntax.

## 1.12.6
The "within" step no longer clashes with the "I should see an element for" and "I click on the element for" steps ([Issue #87](https://github.com/makandra/spreewald/issues/87))

## 1.12.5
The "it should work" step now takes an optional reason.

## 1.12.4
The word "within" can now be used in arguments for other steps without causing errors ([Issue #53](https://github.com/makandra/spreewald/issues/80))

## 1.12.3
Prevent wall of warnings when `Then console` is used multiple times in on test run ([issue](https://github.com/makandra/spreewald/issues/80))

## 1.12.2
Always check the current driver by its class (see [issue](https://github.com/makandra/spreewald/issues/74))

## 1.12.1
- Remove deprecation warnings because of `failure_message_for_should` and `failure_message_for_should_not`

## 1.12.0
- Make Spreewald work without jQuery

## 1.11.6 2018-08-28
- Added CHANGELOG
- Replaced `field_labeled` with `find_field` (https://github.com/teamcapybara/capybara/blob/master/History.md#removed)
