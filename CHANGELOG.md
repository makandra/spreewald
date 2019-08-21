# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 2.3.0
- Deprecate two steps:
  - (Given) the file ... was attached to the ... above\
  - (Then) debugger\

## 2.2.4
- Fix "..." field should have the error "..." test by removing old should syntax
- Add single-line mail step to READNE

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
- Refer to Capybara 3's new flag `Capybara.default_normalize_ws = true` in the READNE,

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

