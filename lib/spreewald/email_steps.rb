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
#       Subject: The subject may contain "quotes"
#       Attachments: ...
#
#       Message body goes here.
#       """
#
# You can skip lines in the header, of course. Note that the mail body is only checked for
# _inclusion_. That means you can only test a prefix of the body. The subject can also be
# a prefix.
Then /^(an|no) e?mail should have been sent with:$/ do |mode, raw_data|
  patiently do
    raw_data.strip!
    header, body = raw_data.split(/\n\n/, 2) # 2: maximum number of fields
    conditions = {}
    header.split("\n").each do |row|
      if row.match(/^[a-z\-]+: /i)
        key, value = row.split(": ", 2)
        conditions[key.underscore.to_sym] = value
      end
    end
    conditions[:body] = body if body
    @mail = MailFinder.find(conditions)
    expectation = mode == 'no' ? 'not_to' : 'to'
    expect(@mail).send(expectation, be_present)
  end
end.overridable

# nodoc
Then /^(an|no) e?mail should have been sent((?: |and|with|from "[^"]+"|bcc "[^"]+"|cc "[^"]+"|to "[^"]+"|the subject "[^"]+"|the body "[^"]+"|the attachments "[^"]+")+)$/ do |mode, query|
  patiently do
    conditions = {}
    conditions[:to] = $1 if query =~ /to "([^"]+)"/
    conditions[:Cc] = $1 if query =~ /cc "([^"]+)"/
    conditions[:bcc] = $1 if query =~ /bcc "([^"]+)"/
    conditions[:from] = $1 if query =~ /from "([^"]+)"/
    conditions[:subject] = $1 if query =~ /the subject "([^"]+)"/
    conditions[:body] = $1 if query =~ /the body "([^"]+)"/
    conditions[:attachments] = $1 if query =~ /the attachments "([^"]+)"/
    @mail = MailFinder.find(conditions)
    expectation = mode == 'no' ? 'not_to' : 'to'
    expect(@mail).send(expectation, be_present)
  end
end.overridable

# Only works after you have retrieved the mail using "Then an email should have been sent with:"
When /^I follow the (first|second|third)? ?link in the e?mail$/ do |index_in_words|
  mail = @mail || ActionMailer::Base.deliveries.last
  index = { nil => 0, 'first' => 0, 'second' => 1, 'third' => 2 }[index_in_words]
  url_pattern = %r{(?:http|https)://[^/]+([^"'\s\\]*)}
  mail_body = MailFinder.email_text_body(mail).to_s
  only_path = mail_body.scan(url_pattern)[index][0]
  visit only_path
end.overridable

Then /^no e?mail should have been sent$/ do
  expect(ActionMailer::Base.deliveries).to be_empty
end.overridable

# Checks that the last sent email includes some text
Then /^I should see "([^\"]*)" in the e?mail$/ do |text|
  expect(MailFinder.email_text_body(ActionMailer::Base.deliveries.last)).to include(text)
end.overridable

# Print all sent emails to STDOUT.
Then /^show me the e?mails$/ do
  ActionMailer::Base.deliveries.each_with_index do |mail, i|
    puts "E-Mail ##{i}"
    print "-" * 80
    puts [ "From:    #{mail.from}",
           "To:      #{mail.to}",
           "Subject: #{mail.subject}",
           "\n" + MailFinder.email_text_body(mail)
         ].join("\n")
    print "-" * 80
  end
end.overridable

# Example:
#
#     And that mail should have the following lines in the body:
#       """
#       All of these lines
#       need to be present
#       """
#
# You can skip lines, of course. Note that the lines are only checked for _inclusion_.
Then /^that e?mail should( not)? have the following lines in the body:$/ do |negate, body|
  expectation = negate ? 'not_to' : 'to'
  mail = @mail || ActionMailer::Base.deliveries.last
  email_text_body = MailFinder.email_text_body(mail)

  body.to_s.strip.split(/\n/).each do |line|
    expect(email_text_body).send(expectation, include(line.strip))
  end
end.overridable

# Checks that the text should be included in the retrieved email
Then /^that e?mail should have the following( content in the)? body:$/ do |_mode, body|
  mail = @mail || ActionMailer::Base.deliveries.last
  expect(MailFinder.email_text_body(mail)).to include(body.strip)
end.overridable
