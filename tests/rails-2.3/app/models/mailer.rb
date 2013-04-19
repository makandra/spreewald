class Mailer < ActionMailer::Base
  
  def email(body_text = "body")
    recipients EMAIL_RECIPIENT
    from EMAIL_SENDER
    subject "email"
    body body_text
  end
  
end
