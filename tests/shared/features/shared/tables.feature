Feature: Table steps

  Background:
    When I go to "/tables/table1"


  Scenario: should see a table with the following rows
    Then the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 1-1 | 1-3 |
        | 2-1 | 2-3 |
        | 3-1 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 1-2 | 1-3 |
        | 2-2 | 2-3 |
        | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 1-1 | 1-3 |
        | 3-1 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows:
        | 1* | 1-3 |
        | 3* | 3-3 |
      """
    And the following multiline step should fail:
      """
      Then I should see a table with the following rows:
        | 3-1 | 3-2 | 3-3 |
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
      """
    But the following multiline step should fail:
      """
      Then I should see a table with the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | foo |
      """
    And the following multiline step should fail:
      """
      Then I should see a table with the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | foo | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should fail:
      """
      Then I should see a table with the following rows:
        | 1 | 1-3 |
        | 3 | 3-3 |
      """


  Scenario: should not see a table with the following rows
    Then the following multiline step should fail:
      """
      Then I should not see a table with the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    But the following multiline step should succeed:
      """
      Then I should not see a table with the following rows:
        | 3-1 | 3-2 | 3-3 |
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
      """


  Scenario: should see a table with exactly the following rows
    Then the following multiline step should succeed:
      """
      Then I should see a table with exactly the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with exactly the following rows:
        | 1-1 | 1-3 |
        | 2-1 | 2-3 |
        | 3-1 | 3-3 |
      """
    But the following multiline step should fail:
      """
      Then I should see a table with exactly the following rows:
        | 2-1 | 2-2 | 2-3 |
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should fail:
      """
      Then I should see a table with exactly the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """

  Scenario: should not see a table with exactly the following rows
    Then the following multiline step should fail:
      """
      Then I should not see a table with exactly the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should fail:
      """
      Then I should not see a table with exactly the following rows:
        | 1-1 | 1-3 |
        | 2-1 | 2-3 |
        | 3-1 | 3-3 |
      """
    But the following multiline step should succeed:
      """
      Then I should not see a table with exactly the following rows:
        | 2-1 | 2-2 | 2-3 |
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should not see a table with exactly the following rows:
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """


  Scenario: should see a table with the following rows in any order
    Then the following multiline step should succeed:
      """
      Then I should see a table with the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with the following rows in any order:
        | 3-1 | 3-2 | 3-3 |
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
      """
    But the following multiline step should fail:
      """
      Then I should see a table with the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | foo |
      """
    And the following multiline step should fail:
      """
      Then I should see a table with the following rows in any order:
        | 1 | 1-3 |
        | 3 | 3-3 |
      """


  Scenario: should not see a table with the following rows in any order
    Then the following multiline step should fail:
      """
      Then I should not see a table with the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should fail:
      """
      Then I should not see a table with the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should fail:
      """
      Then I should not see a table with the following rows in any order:
        | 3-1 | 3-2 | 3-3 |
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
      """
    But the following multiline step should succeed:
      """
      Then I should not see a table with the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | foo |
      """
    And the following multiline step should succeed:
      """
      Then I should not see a table with the following rows in any order:
        | 1 | 1-3 |
        | 3 | 3-3 |
      """


  Scenario: should see a table with exactly the following rows in any order
    Then the following multiline step should succeed:
      """
      Then I should see a table with exactly the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should succeed:
      """
      Then I should see a table with exactly the following rows in any order:
        | 3-1 | 3-2 | 3-3 |
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
      """
    But the following multiline step should fail:
      """
      Then I should see a table with exactly the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """


  Scenario: should not see a table with exactly the following rows in any order
    Then the following multiline step should fail:
      """
      Then I should not see a table with exactly the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
        | 3-1 | 3-2 | 3-3 |
      """
    And the following multiline step should fail:
      """
      Then I should not see a table with exactly the following rows in any order:
        | 3-1 | 3-2 | 3-3 |
        | 1-1 | 1-2 | 1-3 |
        | 2-1 | 2-2 | 2-3 |
      """
    But the following multiline step should succeed:
      """
      Then I should not see a table with exactly the following rows in any order:
        | 1-1 | 1-2 | 1-3 |
        | 3-1 | 3-2 | 3-3 |
      """
