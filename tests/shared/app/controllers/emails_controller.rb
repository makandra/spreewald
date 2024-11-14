class EmailsController < ApplicationController

  def do_nothing
    render_nothing
  end

  def send_email
    deliver :email
    render_nothing
  end

  def send_crlf_email
    deliver :email_crlf
    render_nothing
  end

  def send_email_with_umlauts
    deliver :email_with_umlauts
    render_nothing
  end

  def send_html_email_with_links
    deliver :html_email_with_links
    render_nothing
  end

  def send_text_email_with_links
    deliver :text_email_with_links
    render_nothing
  end

  def send_html_email_with_linebreaks
    deliver :html_email_with_linebreaks
    render_nothing
  end

  def send_html_email_with_specific_line
    deliver :html_email_with_specific_line
    render_nothing
  end

  def send_text_email_with_specific_line
    deliver :text_email_with_specific_line
    render_nothing
  end

  def send_html_email_for_successful_test_without_header
    deliver :html_email_for_successful_test_without_header
    render_nothing
  end

  def send_text_email_for_successful_test_without_header
    deliver :text_email_for_successful_test_without_header
    render_nothing
  end

  def send_html_email_for_failed_test_without_header
    deliver :html_email_for_failed_test_without_header
    render_nothing
  end

  def send_text_email_for_failed_test_without_header
    deliver :text_email_for_failed_test_without_header
    render_nothing
  end

  private

  def deliver(method_name)
    SpreewaldMailer.send(method_name).deliver
  end

end
