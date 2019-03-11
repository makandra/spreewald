Feature: Development steps

  Scenario: /^it should work(.+?)?$/ (without a reason)
    Then it should work

  Scenario: /^it should work(.+?)?$/ (with a given reason)
    Then it should work once the blocker described here was fulfilled. (Feature should be pending)

