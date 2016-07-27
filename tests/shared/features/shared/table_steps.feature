Feature: Table steps


  Scenario: should see a table with the following rows
    When I go to "/tables/table1"
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


  Scenario: Cell content normalization
    When I go to "/tables/table_with_weird_spaces"
    Then I should see a table with the following rows:
      | one two  | three four   |
      | five six | seven eight  |
      | nineten  | eleventwelve |


  Scenario: should not see a table with the following rows
    When I go to "/tables/table1"
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
    When I go to "/tables/table1"
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
    When I go to "/tables/table1"
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
    When I go to "/tables/table1"
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
    When I go to "/tables/table1"
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
    When I go to "/tables/table1"
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
    When I go to "/tables/table1"
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
