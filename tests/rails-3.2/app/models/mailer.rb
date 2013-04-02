class Mailer < ActionMailer::Base
  
  default :from => "from@example.com",
          :to => "to@example.com"
  
  def email(body = "body")
    mail(:subject => "email") do |format|
      format.text { render :text => body }
    end
  end
  
end