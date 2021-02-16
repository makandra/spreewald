require 'nokogiri'

module Spreewald
  class MailToPlaintextConverter
    def initialize(mail, type = '')
      @mail = mail
      @type = type
    end
  
    def run
      body = ''
      if mail.multipart?
        body = if mail.html_part && type != 'plain-text'
          text_from_html(mail.html_part.body.to_s)
        elsif mail.text_part && type != 'HTML'
          mail.text_part.body.to_s
        else
          mail.body.to_s
        end
      else
        if body_text_html?
          body = text_from_html(mail.body.to_s)
        else
          body = mail.body.to_s
        end
      end
      body.gsub("\r\n", "\n") # The mail gem (>= 2.7.1) switched from \n to \r\n line breaks (LF to CRLF) in plain text mails.
    end
  
    private
  
    attr_reader :mail, :type
  
    def body_text_html?
      mail.body.to_s.include? "<html>"
    end
  
    def text_from_html(html)
      Nokogiri::HTML(html).at_css('body').text.gsub(/[\r\n]+/, "\n")
    end
  end
end
