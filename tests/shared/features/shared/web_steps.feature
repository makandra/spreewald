Feature: Web steps

  Scenario: /^the "([^"]*)" field should (not )?contain "([^"]*)"$/
    When I go to "/forms/form1"
    Then the "Text control" field should contain "Text control value"
    Then the "Select control" field should contain "Label 2"
    Then the "Select control without selection" field should contain "Label 1"
    Then the "Textarea control" field should contain "Textarea control value"
    Then the "Empty control" field should contain ""

  Scenario: /^the "([^"]*)" field should (not )?contain:/
    When I go to "/forms/form2"
    Then the "Text control" field should contain:
      """
      Text control value
      """
    Then the "Textarea control" field should contain:
      """
      Textarea control line 1
      Textarea control line 2
      """
    Then the "Empty textarea control" field should contain:
      """
      """

  Scenario: /^I should see a form with the following values:$/
    When I go to "/forms/form1"
    Then I should see a form with the following values:
      | Text control                     | Text control value     |
      | Select control                   | Label 2                |
      | Select control without selection | Label 1                |
      | Textarea control                 | Textarea control value |
      | Empty control                    |                        |


  Scenario: /^"([^"]*)" should be selected for "([^"]*)"$/
    When I go to "/forms/form1"
    Then "Label 2" should be selected for "Select control"
    Then "Label 1" should be selected for "Select control without selection"

  
  Scenario: /^I go back$/
    Given I go to "/static_pages/link_to_home"
      And I follow "Home"
    
    When I go back
    Then I should be on "/static_pages/link_to_home"


  Scenario: /^the "([^"]*)" checkbox should( not)? be checked$/
    When I go to "/forms/checkbox_form"
    Then the "Checked" checkbox should be checked
      And the "Unchecked" checkbox should not be checked


  # We only check for it to not die, reacting to click on arbitrary elements will not work without javascript
  Scenario: /^I click on "([^\"]+)"$/
    When I go to "/static_pages/click_on"
      And I click on "Nested"
      And I click on "Button"


  Scenario: /^the "(.*?)" select should( not)? be sorted$/
    When I go to "/forms/select_fields"
    Then the "sorted" select should be sorted
      But the "unsorted" select should not be sorted


  Scenario: /^Then (the tag )?"..." should( not)? be visible$/
    When I go to "/static_pages/visibility"
    Then "hidden ümläüt" should not be visible
      And "visible ümläüt" should be visible
      And a hidden string with quotes should not be visible
      And a visible string with quotes should be visible
      And "hidden ümläüt" should be hidden


  @javascript
  Scenario: /^Then (the tag )?"..." should( not)? be visible$/ with javascript
    When I go to "/static_pages/visibility"
    Then "hidden ümläüt" should not be visible
    And "visible ümläüt" should be visible
    And a hidden string with quotes should not be visible
    And a visible string with quotes should be visible
    And "hidden ümläüt" should be hidden

  Scenario: /^I should (not )?see (?:|a|an |the )(.*?) element$/
    When I go to "/static_pages/see_element"
    Then I should see a ".panel" element
      And I should see the ".panel" element
      And I should see a panel element
      But I should not see a ".timeline" element
      And I should not see the ".timeline" element
      And I should not see the timeline element
