module Spreewald
  module Steps
    class FollowTheLink
      class NoVisitableLinkFound < StandardError
        def initialize(paths, index)
          error_message = <<~MESSAGE
            Could not follow the #{index} link in the email.
          MESSAGE
          if paths&.empty?
            error_message << "Found no link paths in the email."
          else
            error_message << "Found these link paths in the email: #{paths.join(', ')}"
          end
          super(error_message)
        end
      end

      URL_PATTERN = %r((?:https?://[^/]+)([^"'\s]+))

      def initialize(mail, index_in_words)
        @mail = mail
        @index_in_words = index_in_words
      end

      def run
        index = { nil => 0, 'first' => 0, 'second' => 1, 'third' => 2 }[@index_in_words]

        paths = if @mail.html_part || body_text_html?
          search_for_links_in_html
        else
          search_for_links_in_plaintext
        end

        if paths[index]
          visit_path paths[index]
        else
          raise NoVisitableLinkFound.new(paths, @index_in_words) unless paths[index]
        end
      end

      private

      def visit_path(path)
        Capybara.visit(path)
      end

      def body_text_html?
        @mail.body.to_s.include? "<html>"
      end

      def search_for_links_in_html
        body = @mail.html_part ? @mail.html_part.body : @mail.body
        dom = Nokogiri::HTML(body.to_s)
        (dom / 'a[href]').map { |a| a['href'].match(URL_PATTERN) }.compact.map { |match| match[1] }
      end

      def search_for_links_in_plaintext
        mail_body = MailFinder.email_text_body(@mail).to_s
        mail_body.scan(URL_PATTERN).flatten(1)
      end
    end
  end
end
