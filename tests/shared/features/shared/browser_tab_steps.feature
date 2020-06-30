@javascript
Feature: Browser tab steps

  Background: Access some content in a first tab
    Given I go to "/static_pages/tab_1"
    Then I should see "First browser tab"
      And there should be 1 browser tab


  Scenario: I open (.+?) in a new browser tab
    When I open "/static_pages/tab_2" in a new browser tab
    Then I should see "Second browser tab"
      And there should be 2 browser tabs

    When I open "/static_pages/tab_3" in a new browser tab
    Then I should see "Third browser tab"
      And there should be 3 browser tabs


  Scenario: I close the browser tab
    When I open "/static_pages/tab_2" in a new browser tab
      And I open "/static_pages/tab_3" in a new browser tab
    Then I should see "Third browser tab"
      And there should be 3 browser tabs

    When I close the browser tab
    Then there should be 2 browser tabs
      And I should see "First browser tab"

    When I close the browser tab
    Then there should be 1 browser tab
      And I should see "Second browser tab"


  Scenario: I switch to the new(?:ly opened)? browser tab
    When I follow "Click to open tab 2"
    Then I should see "First browser tab"

    When I switch to the newly opened browser tab
    Then I should see "Second browser tab"

    When I follow "Click to open tab 3"
      And I switch to the new browser tab
    Then I should see "Third browser tab"


  Scenario: I switch(?: back)? to the previous browser tab
    When I open "/static_pages/tab_2" in a new browser tab
    Then I should see "Second browser tab"
      And there should be 2 browser tabs

    When I switch back to the previous browser tab
    Then I should see "First browser tab"
      And there should be 2 browser tabs

    And I open "/static_pages/tab_3" in a new browser tab
    Then I should see "Third browser tab"
      And there should be 3 browser tabs

    When I switch to the previous browser tab
    Then I should see "Second browser tab"
      And there should be 3 browser tabs


    Scenario: I should have opened a new browser tab
      This step must be preceded by "I may open a new browser tab"

      When I may open a new browser tab
        And I follow "Click to open tab 2"
      Then I should have opened a new browser tab
        And there should be 2 browser tabs


    Scenario: I should not have opened a new browser tab
      This step must be preceded by "I may open a new browser tab"

      When I may open a new browser tab
        And I follow "Follow link WITHOUT opening a new tab"
      Then I should not have opened a new browser tab
        And there should be 1 browser tabs


    Scenario: there should be (\d+) browser tabs?
      Given there should be 1 browser tab
      When I open "/static_pages/tab_2" in a new browser tab
      Then there should be 2 browser tabs

      When I open "/static_pages/tab_3" in a new browser tab
      Then there should be 3 browser tabs

      When I open "/static_pages/tab_3" in a new browser tab
      Then there should be 4 browser tabs


    Scenario: there should be at least (\d+) browser tabs?
      Given there should be at least 1 browser tab
      When I open "/static_pages/tab_2" in a new browser tab
      Then there should be at least 2 browser tabs

      When I open "/static_pages/tab_3" in a new browser tab
      Then there should be at least 1 browser tabs
      Then there should be at least 2 browser tabs
      Then there should be at least 3 browser tabs
