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

  private

  def deliver(method_name)
    case
    when Rails.version.to_i >= 5
      SpreewaldMailer.send(method_name).deliver
    when Rails.version.to_i >= 3
      Mailer.public_send(method_name).deliver
    else
      Mailer.public_send("deliver_#{method_name}")
    end
  end

end
