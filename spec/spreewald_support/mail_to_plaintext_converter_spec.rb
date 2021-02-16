require "spreewald_support/mail_to_plaintext_converter"
require "mail"

describe Spreewald::MailToPlaintextConverter do
  describe '#run' do
    context 'with multipart email' do
      let(:multipart_email) do
        Mail.new do
          text_part do
            body "email text part"
          end

          html_part do
            body "<html><body><p>html email text</p></body></html>"
          end
        end
      end

      it 'uses the html part as source as default' do
        output = Spreewald::MailToPlaintextConverter.new(multipart_email).run
        expect(output).to eq 'html email text'
      end

      it 'uses the text part as source if specified as type' do
        output = Spreewald::MailToPlaintextConverter.new(multipart_email, 'plain-text').run
        expect(output).to eq 'email text part'
      end

      it 'uses the html part as source if specified as type' do
        output = Spreewald::MailToPlaintextConverter.new(multipart_email, 'HTML').run
        expect(output).to eq 'html email text'
      end
    end

    context 'without multipart email' do
      it 'recognizes the plaintext' do
        plaintext_email = Mail.new(body: 'Hello RSpec')
        output = Spreewald::MailToPlaintextConverter.new(plaintext_email).run
        expect(output).to eq 'Hello RSpec'
      end

      it 'recognizes html content' do
        plaintext_email = Mail.new(body: <<-HTML)
        <html><body><p>this is html!</p></body></html>
        HTML
        output = Spreewald::MailToPlaintextConverter.new(plaintext_email).run
        expect(output).to eq 'this is html!'
      end

      it 'recognizes multiple paragraph content' do
        plaintext_email = Mail.new(body: <<~HTML)
        <html><body><p>this is line1</p>
        <p>this is line2</p></body></html>
        HTML
        output = Spreewald::MailToPlaintextConverter.new(plaintext_email).run
        expect(output).to eq "this is line1\nthis is line2"
      end
    end
  end
end
