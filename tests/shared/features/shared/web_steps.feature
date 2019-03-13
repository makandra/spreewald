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


  Scenario: /^"([^"]*)" should( not)? be selected for "([^"]*)"$/
    When I go to "/forms/form1"
    Then "Label 2" should be selected for "Select control"
      But "Label 1" should not be selected for "Select control"
      And "Label 1" should be selected for "Select control without selection"


  Scenario: /^nothing should be selected for "([^"]*)"$/
    When I go to "/forms/form1"
    Then nothing should be selected for "Select control with blank option"
    Then nothing should be selected for "Select control with blank selection"

  
  Scenario: /^I go back$/
    Given I go to "/static_pages/link_to_home"
      And I follow "Home"
    
    When I go back
    Then I should be on "/static_pages/link_to_home"


  Scenario: /^the "([^"]*)" checkbox should( not)? be checked$/
    When I go to "/forms/checkbox_form"
    Then the "Checked" checkbox should be checked
      And the "Unchecked" checkbox should not be checked


  @javascript
  Scenario: /^I click on "([^\"]+)"$/
    When I go to "/static_pages/click_on"
      And I click on "Nested"
    # See that it clicks the innermost element with that text
    Then I should see "You clicked on .inner"
    When I click on "Button"
    Then I should see "You clicked on .button"


  @javascript
  Scenario: /^I click on the element "([^\"]+)"$/
    When I go to "/static_pages/click_on"
    And I click on the element ".inner"
    Then I should see "You clicked on .inner"
    When I click on the element ".button"
    Then I should see "You clicked on .button"


  @javascript
  Scenario: /^I click on the element for .*?$/
    When I go to "/static_pages/click_on"
    And I click on the element for a panel
    Then I should see "You clicked on .panel"
    When I click on the element for the timeline
    Then I should see "You clicked on .timeline"


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


  Scenario: /^the "([^\"]*)" field should( not)? be visible$/
    When I go to "/static_pages/visibility"
    Then the "Visible field" field should be visible
      But the "Hidden field" field should not be visible


  @javascript
  Scenario: /^the "([^\"]*)" field should( not)? be visible$/ with Javascript
    When I go to "/static_pages/visibility"
    Then the "Visible field" field should be visible
      But the "Hidden field" field should not be visible


  Scenario: /^I should (not )?see (?:|a|an |the )(.*?) element$/
    When I go to "/static_pages/see_element"
    Then I should see an element ".panel"
      And I should see the element ".panel"
      And I should see an element for a panel
      And I should see the element for a panel
      But I should not see an element ".timeline"
      But I should not see the element ".timeline"
      And I should not see an element for the timeline
      And I should not see the element for the timeline


  Scenario: /^(.*) within (.*[^:])$/
    When I go to "/static_pages/within"
    Then I should see an element ".child1" within ".container1"
      But I should not see an element ".child1" within ".container2"


  Scenario: /^(.*) within (.*[^:])$/ with a Capybara::Node::Element
    When I go to "/static_pages/within"
    Then I should see "All" within the table row containing "Admin"


  Scenario: /^I perform basic authentication as "([^\"]*)\/([^\"]*)" and go to (.*)$/
    When I go to "/authenticated/page"
    Then I should see "Access denied"
    When I perform basic authentication as "user/password" and go to "/authenticated/page"
    Then I should see "Action reached"


  @javascript
  Scenario: /^I perform basic authentication as "([^\"]*)\/([^\"]*)" and go to (.*)$/ with Javascript
    When I perform basic authentication as "user/password" and go to "/authenticated/page"
    Then I should see "Action reached"
