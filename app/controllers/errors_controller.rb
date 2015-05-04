class ErrorsController < ApplicationController
  skip_before_action :clear_intended_uri
  
  def routing
    flash[:error] = "Oops! The page you were looking for does not exist. You may have mistyped the address or the page may have moved."
    redirect_to root_path
  end
end
