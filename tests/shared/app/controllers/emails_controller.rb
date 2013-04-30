class EmailsController < ApplicationController

  def do_nothing
    render :nothing => true
  end
  
  def send_email
    text = params[:id].to_s
    
    if Rails.version >= "3"
      Mailer.email(text).deliver
    else
      Mailer.deliver_email(text)
    end

    render :nothing => true
  end

end
