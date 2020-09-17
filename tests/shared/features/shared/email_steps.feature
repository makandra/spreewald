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
      | I should see "Body" in the email |
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

        Body
        with
        line
        breaks
        '''
      """

    # Test with end-of-line wildcards
    Then the following multiline step should succeed:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        Bo*
        wi*
        li*
        br*
        '''
      """

    # Test with multiple-line wildcards
    Then the following multiline step should succeed:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        Body
        *
        breaks
        '''
      """

    # Test with the whole body being a multiple-line wildcard
    Then the following multiline step should succeed:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        *
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

        Body
        with
        line
        breaks
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

        Body
        with
        line
        breaks
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

        Body
        with
        line
        breaks
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

        Body
        with
        line
        breaks
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

        Other body
        with
        line
        breaks
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

        Body
        with
        line
        breaks

        MORE-BODY
        '''
      """

    # Test body with wildcard not at the end of a line
    Then the following multiline step should fail:
      """
      Then an email should have been sent with:
        '''
        From: from@example.com
        Reply-To: reply-to@example.com
        To: to@example.com
        Subject: SUBJECT

        Body
        *th
        line
        break
        '''
      """

  Scenario: Scenario: /^(an|no) e?mail should have been sent((?: |and|with|from "[^"]+"|bcc "[^"]+"|cc "[^"]+"|to "[^"]+"|the subject "[^"]+"|the body "[^"]+"|the attachments "[^"]+")+)$/
    When I go to "/emails/send_email"

    # Test with correct conditions
    Then the following multiline step should succeed:
      """
      Then an email should have been sent from "from@example.com" to "to@example.com" cc "cc@example.com" bcc "bcc@example.com" and the subject "SUBJECT" and the attachments "attached_file.pdf"
      """

     # Test with wrong conditions
    Then the following multiline step should fail:
      """
      Then an email should have been sent from "from@example.com" to "to@example.com" cc "cc@example.com" bcc "wrong_bcc@example.com" and the subject "SUBJECT" and the attachments "attached_file.pdf"
      """

  Scenario: /^that e?mail should have the following lines in the body:$/
    When I go to "/emails/send_email"

    # Test with correct body lines
    Then the following multiline step should succeed:
      """
      Then that email should have the following lines in the body:
        '''
        with
        line
        '''
      """

    # Test with wrong body lines
    Then the following multiline step should fail:
      """
      Then that email should have the following lines in the body:
        '''
        wrong
        line
        '''
      """


  Scenario: /^that e?mail should have the following( content in the)? body$/
    When I go to "/emails/send_email"

      # Test with correct body lines
    Then the following multiline step should succeed:
      """
      Then that email should have the following content in the body:
        '''
        with
        line
        '''
      """

       # Test with wrong body lines
    Then the following multiline step should fail:
      """
      Then that email should have the following body:
        '''
        wrong
        line
        '''
      """


  Scenario: /^I follow the (first|second|third)? ?link in the e?mail$/ (HTML e-mail body)
    When I go to "/emails/send_html_email_with_links"
      And I follow the first link in the email
    Then I should be on "/static_pages/link_target"

    When I follow the second link in the email
    Then I should be on "/static_pages/second_link_target"


  Scenario: /^I follow the (first|second|third)? ?link in the e?mail$/ (text e-mail body)
    When I go to "/emails/send_text_email_with_links"
      And I follow the first link in the email
    Then I should be on "/static_pages/link_target"

    When I follow the second link in the email
    Then I should be on "/static_pages/second_link_target"
