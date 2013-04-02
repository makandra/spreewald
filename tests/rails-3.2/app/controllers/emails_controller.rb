class EmailsController < ApplicationController

  def do_nothing
    render :nothing => true
  end
  
  def send_email
    text = params[:id]
    
    Mailer.email(text).deliver
    render :nothing => true
  end

end