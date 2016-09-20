class AuthenticatedController < ApplicationController

  before_filter :authenticate

  def page
    render :text => 'Action reached'
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'user' && password == 'password'
    end
  end

end
