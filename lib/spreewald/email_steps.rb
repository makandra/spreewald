# coding: UTF-8

require 'spreewald_support/mail_finder'

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
  index = { nil => 0, 'first' => 0, 'second' => 1, 'third' => 2 }[index_in_words]
  url_pattern = %r((?:https?://[^/]+)([^"'\s]+))

  paths = if mail.html_part
    dom = Nokogiri::HTML(mail.html_part.body.to_s)
    (dom / 'a[href]').map { |a| a['href'].match(url_pattern) }.compact.map { |match| match[1] }
  else
    mail_body = MailFinder.email_text_body(mail).to_s
    mail_body.scan(url_pattern).flatten(1)
  end

  visit paths[index]
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
  if ActionMailer::Base.deliveries.empty?
    puts MailFinder.show_mails(ActionMailer::Base.deliveries, only_header)
  else
    puts "No emails found" if ActionMailer::Base.deliveries.empty?
  end

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
