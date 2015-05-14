class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :clear_intended_uri
  before_action :redirect_to_lacquerloveandlend if Rails.env.production?
  skip_before_action :clear_intended_uri, only: [:is_an_email_address?, :parse_list_of_emails, :current_user, :redirect_to_originated_from_or_root]

  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  rescue_from ActionView::MissingTemplate do |exception|
    # use exception.path to extract the path information
    # This does not work for partials
    flash[:alert] = "We could not find the page you were looking for!"
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # use exception.path to extract the path information
    # This does not work for partials
    flash[:alert] = "Sorry! We could not find what you were looking for."
    redirect_to root_path
  end

  before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }

  private

    def set_current_user
      @user = current_user
    end

    def redirect_to_lacquerloveandlend
      domain_to_redirect_to = 'lacquerloveandlend.com'
      domain_exceptions = ['lacquerloveandlend.com', 'www.lacquerloveandlend.com']
      should_redirect = !(domain_exceptions.include? request.host)
      new_url = "#{request.protocol}#{domain_to_redirect_to}#{request.fullpath}"
      redirect_to new_url, status: :moved_permanently if should_redirect
    end

    def clear_intended_uri
      if session[:intended_uri]
        session[:intended_uri] = nil
      end
    end

    def is_an_email_address?(string)
      !!string.match(/[a-zA-Z\d]+\w*(?:\.\w+)*@[a-zA-Z\d-]+\.[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*/)
    end
    helper_method :is_an_email_address?

    # return an array of email addresses from a string
    def parse_list_of_emails(string)
      string.scan(/[a-zA-Z\d]+\w*(?:\.\w+)*@[a-zA-Z\d-]+\.[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*/)
    end
    helper_method :parse_list_of_emails

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def redirect_to_originated_from_or_root
      if session[:originated_from_uri]
        redirect_to session[:originated_from_uri]
      else 
        redirect_to root_path
      end
    end
    helper_method :redirect_to_originated_from_or_root
end
