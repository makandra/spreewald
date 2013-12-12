Feature: Web steps

  Background:
    When I go to "/forms/form1"

  Scenario: /^the "([^"]*)" field should (not )?contain "([^"]*)"$/
    Then the "Text control" field should contain "Text control value"
    Then the "Select control" field should contain "Label 2"
    Then the "Select control without selection" field should contain "Label 1"
    Then the "Textarea control" field should contain "Textarea control value"
    Then the "Empty control" field should contain ""

  Scenario: /^I should see a form with the following values:$/
    Then I should see a form with the following values:
      | Text control                     | Text control value     |
      | Select control                   | Label 2                |
      | Select control without selection | Label 1                |
      | Textarea control                 | Textarea control value |
      | Empty control                    |                        |

  Scenario: /^"([^"]*)" should be selected for "([^"]*)"$/
    Then "Label 2" should be selected for "Select control"
    Then "Label 1" should be selected for "Select control without selection"

