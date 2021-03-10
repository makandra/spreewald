module Spreewald
  SUPPORTED_EMAIL_HEADERS = ["To", "CC", "BCC", "From", "Reply-To", "Subject", "Attachments"]

  class UnsupportedEmailHeader < StandardError
    attr_reader :header, :value

    def initialize(header, value)
      @header, @value = header, value
      error_message = <<-MESSAGE.strip_heredoc
        It looks like you're trying to match against an unsupported header "#{header}".
        The following headers are supported: #{supported_headers_list}
      MESSAGE
      super(error_message)
    end

    private

    def supported_headers_list
      SUPPORTED_EMAIL_HEADERS.join(", ")
    end
  end
end
