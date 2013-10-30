class EmailsController < ApplicationController

  def do_nothing
    render :nothing => true
  end
  
  def send_email
    if Rails.version >= "3"
      Mailer.email.deliver
    else
      Mailer.deliver_email
    end

    render :nothing => true
  end

end
