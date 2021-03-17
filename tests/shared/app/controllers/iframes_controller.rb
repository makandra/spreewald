class IframesController < ApplicationController

  def iframe_1_content
    render 'iframes/iframe_1_content', layout: false
  end

  def iframe_2_content
    render 'iframes/iframe_2_content', layout: false
  end

end