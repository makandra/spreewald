Feature: Web steps

  Scenario: /^the "([^"]*)" field should (not )?contain "([^"]*)"$/
    When I go to "/forms/form1"
    Then the "Text control" field should contain "Text control value"
    Then the "Text control" field should not contain "false text"
    Then the "Disabled text control" field should contain "Disabled text control value"
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
    Then the "Textarea control" field should not contain:
      """
      Textarea control wrong line 1
      Textarea control wrong line 2
      """
    Then the "Empty textarea control" field should contain:
      """
      """


  Scenario: /^the "([^\"]*)" field should( not)? have an error$/
    When I go to "/forms/invalid_form"
    Then the "A" field should have an error
    Then the "B" field should have an error
    Then the "Disabled" field should have an error
    Then the "C" field should not have an error

  Scenario: /^the "([^"]*)" field should have the error "([^"]*)"$/
    When I go to "/forms/invalid_form"
    Then the "A" field should have the error "is invalid"
    Then the "B" field should have the error "is invalid"
    Then the "Disabled" field should have the error "is invalid"


  Scenario: /^the "([^"]*)" field should have no error$/
    When I go to "/forms/invalid_form"
    Then the "C" field should have no error


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

  Scenario: /^the radio button "([^"]*)" should( not)? be (?:checked|selected)$/
    When I go to "/forms/form1"
    Then the radio button "Radio 1" should not be selected
    Then the radio button "Radio 2" should not be selected
    When I choose "Radio 1"
    Then the radio button "Radio 1" should be selected
    Then the radio button "Radio 2" should not be selected
    When I choose "Radio 2"
    Then the radio button "Radio 1" should not be selected
    Then the radio button "Radio 2" should be selected


  Scenario: /^I go back$/
    Given I go to "/static_pages/link_to_home"
      And I follow "Home"

    When I go back
    Then I should be on "/static_pages/link_to_home"


  Scenario: /^the "([^"]*)" checkbox should( not)? be checked$/
    When I go to "/forms/checkbox_form"
    Then the "Checked" checkbox should be checked
      And the "Checked disabled" checkbox should be checked
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
      But I should not see "You clicked on .panel"

    When I click on the element for a panel within ".clickables"
    Then I should see "You clicked on .panel"


  Scenario: /^the "(.*?)" select should( not)? be sorted$/
    When I go to "/forms/select_fields"
    Then the "sorted" select should be sorted
      But the "unsorted" select should not be sorted


  Scenario: /^Then (the tag )?"..." should( not)? be visible$/
    When I go to "/static_pages/visibility"
    Then "hidden ümläüt" should be hidden
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
      And "hidden ümläüt" should not be visible


  Scenario: /^the "([^\"]*)" field should( not)? be visible$/
    When I go to "/static_pages/visibility"
    Then the "Visible field" field should be visible
      But the "Hidden field" field should not be visible

  Scenario: /^the "([^\"]*)" field should( not)? be visible within (.*[^:])$/
    When I go to "/static_pages/visibility"
    Then "content" should not be visible within ".inside"
      But "content" should be visible within ".outside"

  @javascript
  Scenario: /^the "([^\"]*)" field should( not)? be visible$/ with Javascript
    When I go to "/static_pages/visibility"
    Then the "Visible field" field should be visible
      But the "Hidden field" field should not be visible


  Scenario: /^(the tag )?"([^\"]+)" should be hidden$/ with javascript
    When I go to "/static_pages/visibility"
    Then "div with class: hidden" should be hidden
      And "div with style: display: none" should be hidden
      And "div with class: invisible" should be hidden


  @javascript
  Scenario: /^(the tag )?"([^\"]+)" should be hidden$/
    When I go to "/static_pages/visibility"
      And "div with style: display: none" should be hidden

  Scenario: /^(the tag )?"([^\"]+)" should be hidden within (.*[^:])$/
    When I go to "/static_pages/visibility"
    Then "content" should be hidden within ".inside"


  Scenario: /^(the tag )?"([^\"]+)" should be hidden$/ within container with javascript
    When I go to "/static_pages/visibility"
    Then "div with class: hidden" should be hidden within ".container"
    And "div with style: display: none" should be hidden within ".container"
    And "div with class: invisible" should be hidden within ".container"


  @javascript
  Scenario: /^(the tag )?"([^\"]+)" should be hidden$/ within container
    When I go to "/static_pages/visibility"
    And "div with style: display: none" should be hidden within ".container"


  Scenario: /^I should (not )?see (?:an|the) element "([^"]+)"$/
    When I go to "/static_pages/see_element"
    Then I should see an element ".panel"
      And I should see the element ".panel"
      And I should see the element ".panel--nested-contents" within ".panel"
      And I should see the element ".panel--nested-contents" within a panel
      But I should not see an element ".timeline"
      But I should not see the element ".timeline"


  Scenario: /^I should (not )?see (?:an|the) element for (.*?)$/
    When I go to "/static_pages/see_element"
    Then I should see an element for a panel
      And I should see the element for a panel
      And I should see the element for a panels nested contents within ".panel"
      And I should see the element for a panels nested contents within a panel
      And I should not see an element for the timeline
      And I should not see the element for the timeline


  Scenario: /^((?:|I )should see "([^"]*)" within (.*[^:])$/
    When I go to "/static_pages/within"
    Then I should see "Role" within ".table"
      And I should see "Permissions" within a table
    But I should not see "Nonsense" within ".table"
      And I should not see "Nonsense" within a table

    # making sure it works with a within scope correctly when the same element is available outside
    Then I should not see "Outside Table" within ".table"
      And I should not see "Outside Table" within a table
    But I should see "Outside Table"

  Scenario: /^(?:|I )should see \/([^\/]*)\/$/
    When I go to "/static_pages/within"
    Then I should see /Shared Text/
      And I should see /Unique Text/
      And I should see /http://example.com/
      And I should see /\^Will this text with special Regex characters match\.\.\?\$/
    But I should not see /Nonsense/
      And I should not see /http://other-domain.com/

    # making sure it works with a within scope correctly when the same element is available outside
    Then I should not see /Outside Table/ within ".table"
      And I should not see /Outside Table/ within a table
    But I should see /Outside Table/


  Scenario: /^(?:|I )should see \/([^\/]*)\/ within (.*[^:])$/
    When I go to "/static_pages/within"
    Then I should see /Shared Text/ within ".scoped-element"
      And I should see /Shared Text/ within ".unrelated-element"
      And I should see /Unique Text/ within ".scoped-element"
      And I should see /http://example.com/ within ".hardly-matchable-texts"
      And I should see /\^Will this text with special Regex characters match\.\.\?\$/ within ".hardly-matchable-texts"
    But I should not see /Unique Text/ within ".unrelated-element"
      And I should not see /http://other-domain.com/ within ".unrelated-element"


  Scenario: /^(.*) within (.*[^:])$/ with a Capybara::Node::Element
    When I go to "/static_pages/within"
    Then I should see "All" within the table row containing "Admin"


  Scenario: the /^(.*) within (.*[^:])$/ step should not be invoked when the word "within" is used in an argument for another step
    When I go to "/static_pages/within"
    Then I should see "He lives within a few miles of Augsburg"


  Scenario: /^I perform basic authentication as "([^\"]*)\/([^\"]*)" and go to (.*)$/
    When I go to "/authenticated/page"
    Then I should see "Access denied"
    When I perform basic authentication as "user/password" and go to "/authenticated/page"
    Then I should see "Action reached"


  @javascript
  Scenario: /^I perform basic authentication as "([^\"]*)\/([^\"]*)" and go to (.*)$/ with Javascript
    When I perform basic authentication as "user/password" and go to "/authenticated/page"
    Then I should see "Action reached"


  @javascript
  Scenario: /^show me the page$/
    When I am on "/static_pages/home"
    Then 'show me the page' should open the page or take a screenshot


  Scenario: /^I should get a download with filename "([^\"]*)"$/
    When I go to "/downloads/spreadsheet"
    Then I should get a download with filename "test - example (today).ods"


  Scenario: /^I should( not)? see a link labeled "([^"]*)"$/
    When I am on "/static_pages/links"
    Then I should see a link labeled "First visible link"
      And I should see a link labeled "First visible link" within ".nested-link"
      And I should see a link labeled "Also matches via the title attribute"
    But I should not see a link labeled "Nonexistent Link"
      And I should not see a link labeled "First visible link" within ".unrelated-element"


  Scenario: /^I should( not)? see a field "([^"]*)"$/
    When I go to "/forms/disabled_elements"
    Then I should see a field "Enabled field #1"
      And I should see a field "Disabled field #1"


  Scenario: /^I should( not)? see the (?:number|amount) ([\-\d,\.]+)(?: (.*?))?$/
    When I am on "/static_pages/numbers"
    Then I should see the number 1
      And I should see the number 2.3
      And I should see the number 4,5
      And I should see the amount -60,72 €
      And I should see the amount 13 €
      And I should see the amount -10,000.99 EUR within ".nested-number"
    But I should not see the number 2,3
      And I should not see the number 4.5
      And I should not see the number 60,72
      And I should not see the amount -60,7 €
      And I should not see the amount -10,000.99 EUR within ".unrelated-element"


  Scenario: /^the "([^\"]*)" button should( not)? be disabled$/
    When I go to "/forms/disabled_elements"
    # buttons
    Then the "Disabled button #1" button should be disabled
      And the "Disabled button #2" button should be disabled
      And the "Disabled button #3" button should be disabled
      And the "Disabled button #4" button should be disabled
    But the "Enabled button #1" button should not be disabled
      And the "Enabled button #2" button should not be disabled

      # checkboxes
      And the "Disabled checkbox #1" checkbox should be disabled
      And the "Disabled checkbox #2" checkbox should be disabled
      And the "Disabled checkbox #3" checkbox should be disabled
    But the "Enabled checkbox #1" checkbox should not be disabled
      And the "Enabled checkbox #2" checkbox should not be disabled

      # fields
      And the "Disabled field #1" field should be disabled
      And the "Disabled field #2" field should be disabled
      And the "Disabled field #3" field should be disabled
    But the "Enabled field #1" field should not be disabled
      And the "Enabled field #2" field should not be disabled

      # radio buttons
      And the "Disabled radio button #1" radio button should be disabled
      And the "Disabled radio button #2" radio button should be disabled
      And the "Disabled radio button #3" radio button should be disabled
    But the "Enabled radio button #1" radio button should not be disabled
      And the "Enabled radio button #2" radio button should not be disabled

  Scenario: /^the window should be titled "([^"]*)"$/
    When I go to "/static_pages/home"
    Then the window should be titled "spreewald test application"
