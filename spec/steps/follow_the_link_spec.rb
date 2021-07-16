require "steps/follow_the_link"

describe Spreewald::Steps::FollowTheLink do
  it "raises helpful error message if no link is found" do
    mail_without_links = Mail.new do
      html_part do
        body "<html><body>no link</body></html>"
      end

      text_part do
        body "no link either"
      end
    end

    step = ->() { Spreewald::Steps::FollowTheLink.new(mail_without_links, "first").run }
    expect(step).to raise_error Spreewald::Steps::FollowTheLink::NoVisitableLinkFound
  end

  it "finds links in multipart html email" do
    mail = Mail.new do
      html_part do
        body "<html><body><a href='https://www.example.com/abc'>a link</a><a href='https://www.example.com/def'>second link</a></body></html>"
      end

      text_part do
        body "no link here"
      end
    end

    step = Spreewald::Steps::FollowTheLink.new(mail, "first") 
    expect(step).to receive(:visit_path).with("/abc")
    step.run
  end

  it "finds the second link in a multipart html email" do
    mail = Mail.new do
      html_part do
        body "<html><body><a href='https://www.example.com/abc'>a link</a><a href='https://www.example.com/def'>second link</a></body></html>"
      end

      text_part do
        body "no link here"
      end
    end

    step = Spreewald::Steps::FollowTheLink.new(mail, "second") 
    expect(step).to receive(:visit_path).with("/def")
    step.run
  end

  it "finds links in html email" do
    mail = Mail.new do
      text_part do
        body "my link: https://www.example.com/abc"
      end
    end

    step = Spreewald::Steps::FollowTheLink.new(mail, "first") 
    expect(step).to receive(:visit_path).with("/abc")
    step.run
  end

  it "finds links in non multipart text emails" do
    plaintext_email = Mail.new(body: 'a link: https://www.example.com/abc')
    step = Spreewald::Steps::FollowTheLink.new(plaintext_email, "first") 

    expect(step).to receive(:visit_path).with("/abc")
    step.run
  end

  it "finds links in non multipart html emails" do
    html_mail = Mail.new(body: <<-HTML)
    <html><body><a href="https://www.example.com/abc">this is a link!</a></body></html>
    HTML
    step = Spreewald::Steps::FollowTheLink.new(html_mail, "first") 

    expect(step).to receive(:visit_path).with("/abc")
    step.run
  end
end

