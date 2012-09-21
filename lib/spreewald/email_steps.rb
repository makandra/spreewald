require 'spreewald_support/mail_finder'

Before do
  ActionMailer::Base.deliveries.clear
end

When /^I clear my emails$/ do
  ActionMailer::Base.deliveries.clear
end

Then /^(an|no) e?mail should have been sent((?: |and|with|from "[^"]+"|to "[^"]+"|the subject "[^"]+"|the body "[^"]+"|the attachments "[^"]+")+)$/ do |mode, query|
  conditions = {}
  conditions[:to] = $1 if query =~ /to "([^"]+)"/
  conditions[:cc] = $1 if query =~ / cc "([^"]+)"/
  conditions[:bcc] = $1 if query =~ /bcc "([^"]+)"/
  conditions[:from] = $1 if query =~ /from "([^"]+)"/
  conditions[:subject] = $1 if query =~ /the subject "([^"]+)"/
  conditions[:body] = $1 if query =~ /the body "([^"]+)"/
  conditions[:attachments] = $1 if query =~ /the attachments "([^"]+)"/
  @mail = MailFinder.find(conditions)
  expectation = mode == 'no' ? 'should_not' : 'should'
  @mail.send(expectation, be_present)
end

When /^I follow the (first|second|third)? ?link in the e?mail$/ do |index_in_words|
  mail = @mail || ActionMailer::Base.deliveries.last
  index = { nil => 0, 'first' => 0, 'second' => 1, 'third' => 2 }[index_in_words]
  visit mail.body.scan(Patterns::URL)[index][2]
end

Then /^no e?mail should have been sent$/ do
  ActionMailer::Base.deliveries.should be_empty
end

Then /^I should see "([^\"]*)" in the e?mail$/ do |text|
  ActionMailer::Base.deliveries.last.body.should include(text)
end

Then /^show me the e?mails$/ do
  ActionMailer::Base.deliveries.each do |mail|
    p [mail.from, mail.to, mail.subject]
  end
end

Then /^(an|no) e?mail should have been sent with:$/ do |mode, raw_data|
  raw_data.strip!
  conditions = {}.tap do |hash|
    raw_data.split("\n").each do |row|
      if row.match(/^[a-z]+: /i)
        key, value = row.split(": ", 2)
        hash[key.downcase.to_sym] = value
      end
    end
  end
  @mail = MailFinder.find(conditions)
  expectation = mode == 'no' ? 'should_not' : 'should'
  @mail.send(expectation, be_present)
end

Then /^that e?mail should have the following lines in the body:$/ do |body|
  body.each do |line|
    @mail.body.should include(line.strip)
  end
end

Then /^that e?mail should have the following body:$/ do |body|
  @mail.body.should include(body.strip)
end
