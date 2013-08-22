Feature: Test Spreewald's email steps
  
  Scenario: /^no e?mail should have been sent$/
    When I go to "/emails/do_nothing"
    Then the following step should succeed:
      | no email should have been sent |
  
    When I go to "/emails/send_email"
    Then the following step should fail:
      | no email should have been sent |


  Scenario: /^I should see "([^\"]*)" in the e?mail$/
    When I go to "/emails/send_email/message_body"
    Then the following step should succeed:
      | I should see "message_body" in the email |
