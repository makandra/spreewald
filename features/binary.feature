Feature: The `spreewald` binary

  Scenario: Without arguments, it prints a list of all its steps
    When I run `spreewald`
    Then the output should contain "# All Spreewald steps"
      And the output should contain "Then it should work"


  Scenario: With an argument, it filters the steps by that string
    When I run `spreewald table`
    Then the output should contain:
    """
    # All Spreewald steps containing 'table'
    Then I should( not)? see a table with (exactly )?the following rows( in any order)?
    """
    But the output should not contain "mail"
      And the output should not contain "field"


  Scenario: It includes project steps, if present
    Given a file named "features/step_definitions/test_steps.rb" with:
    """
    Then /^there is a test step$/ do
      # Just testing
    end
    """
      And a file named "features/step_definitions/nested/nested_steps.rb" with:
      """
      Then /^there is a nested test step$/ do
        # Nested step testing
      end
      """

    When I run `spreewald`
    Then the output should contain "Then there is a test step"
      And the output should contain "Then there is a nested test step"
