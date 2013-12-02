Feature: Drag and drop

  Background:
    When I go to "/dragndrops/list1"

  Scenario: /^I drag the list item "([^"]*)" onto "([^"]*)"$/
    # 1 2 3
    Then I drag the list item "List Element 1" onto "List Element 2"
    # 2 1 3
    Then I drag the list item "List Element 2" onto "List Element 3"
    # 3 1 2
    Then I drag the list item "List Element 1" onto "List Element 3"
    # 1 3 2