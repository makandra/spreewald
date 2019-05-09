# Changelog
All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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

### Compatible changes
- Make Spreewald work without jQuery

## 1.11.6 2018-08-28

### Compatible changes
- Added CHANGELOG
- Replaced `field_labeled` with `find_field` (https://github.com/teamcapybara/capybara/blob/master/History.md#removed)

