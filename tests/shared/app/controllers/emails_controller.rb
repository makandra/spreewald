class EmailsController < ApplicationController

  def do_nothing
    render nothing: true
  end

  def send_email
    deliver :email
    render nothing: true
  end

  def send_html_email_with_links
    deliver :html_email_with_links
    render nothing: true
  end

  def send_text_email_with_links
    deliver :text_email_with_links
    render nothing: true
  end

  private

  def deliver(method_name)
    if Rails.version >= '3'
      Mailer.public_send(method_name).deliver
    else
      Mailer.public_send("deliver_#{method_name}")
    end
  end

end
