# coding: UTF-8
require "spreewald_support/mail_to_plaintext_converter"
require "forwardable"

class MailFinder

  class << self

    attr_accessor :user_identity

    def find(raw_data, type = '')
      header, body = raw_data.split(/\n\n/, 2).map(&:strip_heredoc) # 2: maximum number of fields
      conditions = {}
      header.split("\n").each do |row|
        if row.match(/^[A-Za-z\-]+: /i)
          key, value = row.split(": ", 2)
          raise Spreewald::UnsupportedEmailHeader.new(key, value) unless Spreewald::SUPPORTED_EMAIL_HEADERS.include? key.strip
          conditions[key.strip.underscore.to_sym] = value.strip
        end
      end

      # Interpret all lines as body if there are no header-link lines
      if conditions.blank?
        body = [header, body].join("\n\n")
      end

      filename_method = Rails::VERSION::MAJOR < 3 ? 'original_filename' : 'filename'
      matching_header = ActionMailer::Base.deliveries.select do |mail|
        [ conditions[:to].nil? || mail.to.include?(resolve_email conditions[:to]),
          conditions[:cc].nil? || mail.cc && mail.cc.include?(resolve_email conditions[:cc]),
          conditions[:bcc].nil? || mail.bcc && mail.bcc.include?(resolve_email conditions[:bcc]),
          conditions[:from].nil? || mail.from.include?(resolve_email conditions[:from]),
          conditions[:reply_to].nil? || mail.reply_to.include?(resolve_email conditions[:reply_to]),
          conditions[:subject].nil? || mail.subject.include?(conditions[:subject]),
          conditions[:attachments].nil? || conditions[:attachments].split(/\s*,\s*/).sort == Array(mail.attachments).collect(&:"#{filename_method}").sort
        ].all?
      end

      matching_mails = if body
        body_regex = expected_body_regex(body)
        matching_header.select do |mail|
          body_regex =~ email_text_body(mail, type).strip
        end
      else
        matching_header
      end

      Results.new(matching_mails, matching_header, body_regex)
    end

    def resolve_email(identity)
      if identity =~ /^.+\@.+$/
        identity
      else
        User.send("find_by_#{user_identity || 'email'}!", identity).email
      end
    end

    def header_representation(mail)
      header = ""
      header << "From: #{mail.from}\n"
      header << "Reply-To: #{mail.reply_to.join(', ')}\n" if mail.reply_to
      header << "To: #{mail.to.join(', ')}\n" if mail.to
      header << "CC: #{mail.cc.join(', ')}\n" if mail.cc
      header << "BCC: #{mail.bcc.join(', ')}\n" if mail.bcc
      header << "Subject: #{mail.subject}\n"
    end

    def email_text_body(mail, type = '')
      Spreewald::MailToPlaintextConverter.new(mail, type).run
    end

    def show_mails(mails, only_header = false)
      message = ""
      mails.each_with_index do |mail, i|
        message << "E-Mail ##{i}\n"
        message <<  "-" * 80 + "\n"
        message << header_representation(mail)
        message << "\n" + email_text_body(mail).strip + "\n" unless only_header
        message <<  "-" * 80 + "\n\n"
      end
      message
    end

    def expected_body_regex(expected_body)
      expected = '\A\n' + Regexp.quote(expected_body.strip) + '\n\Z'
      expected.gsub! '\n\*\n', '\n[\s\S]*\n'
      expected.gsub! '\*\n', '.*\n'
      expected.gsub! '\n\*', '\n.*'

      expected.gsub! '\A\n', '\A'
      expected.gsub! '\n\Z', '\Z'

      Regexp.new(expected)
    end

  end
end

class MailFinder::Results < Struct.new(:mails, :matching_header, :body_regex)
  extend Forwardable
  delegate [:size, :one?, :empty?] => :mails

  def many?
    size > 1
  end
end
