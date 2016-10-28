Feature: Overriding Spreewald-steps

  Scenario: The developer should be able to override any Spreewald step without Cucumber raising Cucumber::Ambiguous
    When I go to "/static_pages/overridden"
    Then I should see "overridden value"
