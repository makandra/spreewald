class Mailer < ActionMailer::Base

  if Rails.version >= "3"

    default :from => "from@example.com",
            :to => "to@example.com"

    def email(body = "body")
      mail(:subject => "email") do |format|
        format.text { render :text => body }
      end
    end

  else

    def email(body_text = "body")
      recipients EMAIL_RECIPIENT
      from EMAIL_SENDER
      subject "email"
      body body_text
    end

  end

end
