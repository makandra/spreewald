require 'spreewald_support/mail_finder'

module Spreewald
  module Steps
    class ShowMeTheMails
      def initialize(mails, only_header = false)
        @mails = mails
        @only_header = only_header
      end

      def run
        if @mails.empty?
          puts "No emails found"
        else
          puts MailFinder.show_mails(@mails, @only_header)
        end
      end
    end
  end
end
