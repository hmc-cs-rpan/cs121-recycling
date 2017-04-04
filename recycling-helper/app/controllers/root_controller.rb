class RootController < ApplicationController

  # GET requests to the root URL go here. All we do is render a template that redirects the user to
  # their city if location is enabled, or to the real home page if it is not.
  def redirect
    render '/detect_location'
  end

end
