class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActionView::MissingTemplate do |exception|
    # use exception.path to extract the path information
    # This does not work for partials
    flash[:alert] = "We could not find the page you were looking for!"
    redirect_to root_path
  end

  before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user
    
end
