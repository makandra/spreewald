Feature: Browser session steps

  Scenario: Browser sessions do not interfere with each other
    Given I go to "/static_pages/session_1"
    Then I should see "First capybara session"

    When I go to "/static_pages/session_2" in the browser session "second"
      And I go to "/static_pages/session_3" in the browser session "third"

    # Different pages can be accessed on different browser sessions
    Then I should see "Second capybara session" in the browser session "second"
      And I should see "Third capybara session" in the browser session "third"

    # The default session is not affected by actions in other sessions
    But I should not see "Second capybara session"

    # Other sessions are not affected by the main session
    And I should not see "First capybara session" in the browser session "second"

    # Other sessions are not affected by each other
    And I should not see "Third capybara session" in the browser session "second"


  Scenario: Steps with table arguments work in different browser sessions
    When I go to "/tables/table1" in the browser session "tables"
    Then I should see a table with the following rows in the browser session "tables":
      | 1-1 | 1-2 | 1-3 |
      | 2-1 | 2-2 | 2-3 |
      | 3-1 | 3-2 | 3-3 |
