@javascript
Feature: iframe Steps

  @not-capybara-2
  Scenario: Switch between iframes
    Given I go to "/static_pages/iframe"
    Then I should not see "Kiwi"
      And I should not see "Cherry"

    When I switch to the 1st iframe
    Then I should see "Kiwi"
    But I should not see "Cherry"

    When I switch back to the whole page
    Then I should not see "Kiwi"
      And I should not see "Cherry"

    When I switch to the colors_2 iframe
    Then I should see "Cherry"
    But I should not see "Kiwi"
    # Unfortunately, manual reset for next test is necessary
    When I switch back to the whole page


  Scenario: Accesssing contents of iframes with the "inside the ... frame" step fragment
    Given I go to "/static_pages/iframe"
    Then I should see "Content on main page"
    But I should not see "Fruit"

    Then I should see "Kiwi" inside the 1st iframe
      And I should see "Cherry" inside the colors_2 iframe
      And I should see a table with the following rows inside the colors_1 iframe:
        | Color | Fruit |
        | Green | Kiwi  |
      And I should see a table with the following rows inside the 2nd iframe:
        | Color | Fruit  |
        | Red   | Cherry |
    But I should not see "Content on main page" inside the 1st iframe