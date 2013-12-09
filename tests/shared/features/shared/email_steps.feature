Feature: Test Spreewald's email steps
  
  Scenario: /^no e?mail should have been sent$/
    When I go to "/emails/do_nothing"
    Then the following step should succeed:
      | no email should have been sent |
  
    When I go to "/emails/send_email"
    Then the following step should fail:
      | no email should have been sent |

  Scenario: /^I should see "([^\"]*)" in the e?mail$/
    When I go to "/emails/send_email"
    Then the following step should succeed:
      | I should see "BODY" in the email |
    But the following step should fail:
      | I should see "XYZ" in the email |

  Scenario: /^(an|no) e?mail should have been sent with:$/
    When I go to "/emails/send_email"

    # Test without body
    Then the following multiline step should succeed:
    """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT
        '''
      """

    # Test with body
    Then the following multiline step should succeed:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        BODY
        '''
      """

    # Test with incorrect From header
    Then the following multiline step should fail:
      """
      Then an email should have been sent with:
        '''
        From: other-from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        BODY
        '''
      """

    # Test with incorrect Reply-To header
    Then the following multiline step should fail:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: other-reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        BODY
        '''
      """
    # Test with incorrect To header
    Then the following multiline step should fail:
    """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: other-to@example.com
        Subject: SUBJECT

        BODY
        '''
      """

    # Test with incorrect Subject header
    Then the following multiline step should fail:
    """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: OTHER-SUBJECT

        BODY
        '''
      """

    # Test with incorrect body
    Then the following multiline step should fail:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        OTHER-BODY
        '''
      """

    # Test body with multiple paragraphs
    Then the following multiline step should fail:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        BODY
        
        MORE-BODY
        '''
      """
