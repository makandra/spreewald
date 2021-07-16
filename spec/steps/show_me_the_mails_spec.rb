require "steps/show_me_the_mails"

describe Spreewald::Steps::ShowMeTheMails do
  context "without deliveries" do
    it "logs 'no emails found'" do
      step = Spreewald::Steps::ShowMeTheMails.new([])

      expect { step.run }.to output("No emails found\n").to_stdout
    end

    it "logs 'no emails found' with only headers enabled" do
      step = Spreewald::Steps::ShowMeTheMails.new([], true)

      expect { step.run }.to output("No emails found\n").to_stdout
    end
  end

  context "with deliveries" do
    it "logs the email" do
      mail = Mail.new do
        html_part do
          body "<html><body>html part</body></html>"
        end
      end

      expected_output = <<~TXT
        E-Mail #0
        --------------------------------------------------------------------------------
        From: 
        Subject: 
        
        html part
        --------------------------------------------------------------------------------

      TXT
      step = Spreewald::Steps::ShowMeTheMails.new([mail])
      expect { step.run }.to output(expected_output).to_stdout
    end

    it "logs only headers with only headers enabled" do
      mail = Mail.new do
        html_part do
          body "<html><body>html part</body></html>"
        end
      end

      expected_output = <<~TXT
        E-Mail #0
        --------------------------------------------------------------------------------
        From: 
        Subject: 
        --------------------------------------------------------------------------------

      TXT
      step = Spreewald::Steps::ShowMeTheMails.new([mail], true)
      expect { step.run }.to output(expected_output).to_stdout
    end
  end

  context "with multiple deliveries" do
    it "logs the emails" do
      mail_one = Mail.new do
        html_part do
          body "<html><body>html part</body></html>"
        end
      end

      mail_two = Mail.new do
        html_part do
          body "<html><body>html2 part</body></html>"
        end
      end

      expected_output = <<~TXT
        E-Mail #0
        --------------------------------------------------------------------------------
        From: 
        Subject: 
        
        html part
        --------------------------------------------------------------------------------

        E-Mail #1
        --------------------------------------------------------------------------------
        From: 
        Subject: 
        
        html2 part
        --------------------------------------------------------------------------------

      TXT
      step = Spreewald::Steps::ShowMeTheMails.new([mail_one, mail_two])
      expect { step.run }.to output(expected_output).to_stdout
    end
  end
end
