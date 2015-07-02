# coding: UTF-8

class MailFinder
  class << self

    attr_accessor :user_identity

    def find(conditions)
      filename_method = Rails::VERSION::MAJOR < 3 ? 'original_filename' : 'filename'
      ActionMailer::Base.deliveries.detect do |mail|
        mail_body = email_text_body(mail)
        [ conditions[:to].nil? || mail.to.include?(resolve_email conditions[:to]),
          conditions[:cc].nil? || mail.cc.andand.include?(resolve_email conditions[:cc]),
          conditions[:bcc].nil? || mail.bcc.andand.include?(resolve_email conditions[:bcc]),
          conditions[:from].nil? || mail.from.include?(resolve_email conditions[:from]),
          conditions[:reply_to].nil? || mail.reply_to.include?(resolve_email conditions[:reply_to]),
          conditions[:subject].nil? || mail.subject.include?(conditions[:subject]),
          conditions[:body].nil? || mail_body.include?(conditions[:body]),
          conditions[:attachments].nil? || conditions[:attachments].split(/\s*,\s*/).sort == Array(mail.attachments).collect(&:"#{filename_method}").sort
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
          file << "To: #{mail.to.join(', ')}\n" if mail.to
          file << "Subject: #{mail.subject}\n\n"
          file << email_text_body(mail)
          file << "\n-------------------------\n\n"
        end
      end
    end

    def email_text_body(mail)
      if mail.parts.any?
        mail_bodies = mail.parts.map { |part|
          if part.header.to_s.include?('Quoted-printable')
            if Rails.version.starts_with?('2.3')
              part.body.to_s
            else
              part.decoded
            end
          else
            part.decoded
          end
        }
        mail_bodies.join('\n')

      elsif mail.body.respond_to? :raw_source
        mail.body.raw_source
      else
        mail.body
      end
    end

  end
end
