class Mailer < ActionMailer::Base

  REPLY_TO = "reply-to@example.com"
  TO = "to@example.com"
  CC = "cc@example.com"
  BCC = "bcc@example.com"
  FROM = "from@example.com"
  SUBJECT = "SUBJECT"

  if Rails.version >= "3"

    def email
      attachments['attached_file.pdf'] = File.open("#{Rails.root}/public/fixture_files/attachment.pdf", "w") {}
      mail(
        :from => FROM,
        :reply_to => REPLY_TO,
        :to => TO,
        :cc => CC,
        :bcc => BCC,
        :subject => SUBJECT
      )
    end

  else

    def email
      attachments['attached_file.pdf'] = File.open("#{Rails.root}/public/fixture_files/attachment.pdf", "w") {}
      recipients TO
      reply_to REPLY_TO
      from FROM
      cc CC
      bcc BCC
      subject SUBJECT
      body BODY
    end

  end

end
