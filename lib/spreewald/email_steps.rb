# coding: UTF-8

require 'spreewald_support/mail_finder'
require 'steps/show_me_the_mails'
require 'steps/follow_the_link'

Before do
  ActionMailer::Base.deliveries.clear
end

When /^I clear my e?mails$/ do
  ActionMailer::Base.deliveries.clear
end.overridable

# Example:
#
#     Then an email should have been sent with:
#       """
#       From: max.mustermann@example.com
#       Reply-To: mmuster@gmail.com
#       To: john.doe@example.com
#       CC: jane.doe@example.com
#       BCC: johnny.doe@example.com
#       Subject: The subject may contain "quotes"
#       Attachments: image.jpg, attachment.pdf
#
#       This is the message body. You can use * as a wildcard to omit the rest
#       of a line *
#       Or you can omit multiple lines if the asterisk is the only
#       character in a single line, like this:
#       *
#
#       """
#
# You may skip lines in the header.
# Please note: In older versions of Spreewald, unmentioned body lines were skipped.
# Now you have to use the asterisk explicitly to omit lines in the body.
Then /^(an?|no)( HTML| plain-text|) e?mail should have been sent with:$/ do |mode, type, raw_data|
  patiently do
    results = MailFinder.find(raw_data, type.strip)

    if mode == 'no'
      expect(results).to be_empty
    else
      if results.one?
        @mail = results.mails[0]
      elsif results.many?
        warn <<-WARNING
#{results.size} emails were found with the following conditions.
You may want to make the description more precise or clear the emails in between.
#{raw_data}
WARNING
      else
        message = <<-ERROR
No matching mail was found. There were #{ActionMailer::Base.deliveries.size} mails in total.
#{results.matching_header.size} of those had matching headers.
ERROR
        if results.matching_header.empty?
          message << "Expected\n" + '-' * 80 + "\n"
          message << raw_data.split(/\n\n/, 2)[0] # Show the expected header
          message << "\n" + '-' * 80 + "\n\n"
          message << MailFinder.show_mails(ActionMailer::Base.deliveries, true)
        else
          message << "\nTried to match #{results.body_regex.inspect} in the following mails:\n"
          message << results.matching_header.map { |mail| MailFinder.email_text_body(mail, type.strip).strip.inspect }.join("\n")
          message << "\n"
        end
        raise RSpec::Expectations::ExpectationNotMetError.new(message)
      end
    end
  end
end.overridable

# Please note that this step will only follow HTTP and HTTPS links.
# Other links (such as mailto: or ftp:// links) are ignored.
When /^I follow the (first|second|third)? ?link in the e?mail$/ do |index_in_words|
  mail = @mail || ActionMailer::Base.deliveries.last
  Spreewald::Steps::FollowTheLink.new(mail, index_in_words).run
end.overridable

Then /^no e?mail should have been sent$/ do
  expect(ActionMailer::Base.deliveries).to be_empty
end.overridable

# Checks that the last sent email includes some text
Then /^I should see "([^\"]*)" in the( HTML| plain-text|) e?mail$/ do |text, type|
  expect(MailFinder.email_text_body(ActionMailer::Base.deliveries.last, type.strip)).to include(text)
end.overridable

# Print all sent emails to STDOUT (optionally only the headers).
Then /^show me the e?mail( header)?s$/ do |only_header|
  Spreewald::Steps::ShowMeTheMails.new(ActionMailer::Base.deliveries, only_header).run
end.overridable

# Print a subset of all sent emails to STDOUT
# This uses the same syntax as `Then an email should have been sent with:`
Then /^show me the e?mail( header)?s with:$/ do |only_header, raw_data|
  results = MailFinder.find(raw_data)
  if results.empty?
    if results.matching_header.empty?
      puts "There are no emails matching the given header."
    else
      puts "There are no emails matching the given header and body, but #{results.matching_header.size} matching only the header."
    end
  end

  print MailFinder.show_mails(results.mails, only_header)
end.overridable
