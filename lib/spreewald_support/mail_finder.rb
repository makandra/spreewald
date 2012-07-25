class MailFinder
  class << self

    attr_accessor :user_identity

    def find(conditions)
      ActionMailer::Base.deliveries.detect do |mail|
        [ conditions[:to].nil? || mail.to.include?(resolve_email conditions[:to]),
          conditions[:cc].nil? || mail.cc.andand.include?(resolve_email conditions[:cc]),
          conditions[:bcc].nil? || mail.bcc.andand.include?(resolve_email conditions[:bcc]),
          conditions[:from].nil? || mail.from.include?(resolve_email conditions[:from]),
          conditions[:subject].nil? || mail.subject.include?(conditions[:subject]),
          conditions[:body].nil? || mail.body.include?(conditions[:body]),
          conditions[:attachments].nil? || conditions[:attachments].split(/\s*,\s*/).sort == Array(mail.attachments).collect(&:original_filename).sort
        ].all?
      end.tap do |mail|
        log(mail)
      end
    end

    def resolve_email(identity)
      if identity =~ /^.+\@.+$/
        identity
      else
        User.send("find_by_#{user_identity || 'email'}!", identity).email
      end
    end

    def log(mail)
      if mail.present?
        File.open("log/test_mails.log", "a") do |file|
          file << "From: #{mail.from}\n"
          file << "To: #{mail.to.join(', ')}\n"
          file << "Subject: #{mail.subject}\n\n"
          file << mail.body
          file << "\n-------------------------\n\n"
        end
      end
    end

  end
end
