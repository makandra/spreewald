class AuthenticatedController < ApplicationController

  if Rails.version.to_i >= 5
    before_action :authenticate
  else
    before_filter :authenticate
  end

  def page
    if Rails.version.to_i >= 5
      render :plain => 'Action reached'
    else
      render :text => 'Action reached'
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'user' && password == 'password'
    end
  end

end
