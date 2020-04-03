class ApplicationController < ActionController::Base

  def render_nothing
    if Rails.version.to_i >= 5
      render body: nil
    else
      render nothing: true
    end
  end

end
