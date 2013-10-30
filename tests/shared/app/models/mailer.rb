class Mailer < ActionMailer::Base

  REPLY_TO = "reply-to@example.com"
  TO = "to@example.com"
  FROM = "from@example.com"
  SUBJECT = "SUBJECT"
  BODY = "BODY"

  if Rails.version >= "3"

    def email
      mail(
        :from => FROM,
        :reply_to => REPLY_TO,
        :to => TO,
        :subject => SUBJECT
      ) do |format|
        format.text { render :text => BODY }
      end
    end

  else

    def email
      recipients TO
      reply_to REPLY_TO
      from FROM
      subject SUBJECT
      body BODY
    end

  end

end
