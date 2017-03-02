class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def displayHomepage

  	render 'Webpages/index'
  	
  end
end
