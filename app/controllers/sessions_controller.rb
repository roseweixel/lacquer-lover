class SessionsController < ApplicationController
  def create
    binding.pry
    if request.env['omniauth.auth'].present?
      existing_user = User.find_by(uid: request.env['omniauth.auth']['uid'])
      user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      if !existing_user
        flash[:notice] = "Welcome to Lacquer Love&Lend! Start adding lacquers to your collection and finding friends to add to your network!"
      end
      # TODO: MAKE SURE INTENDED_URI IS CLEARED OUT ONCE THE USER HAS NAVIGATED AWAY FROM THE LANDING PAGE
      if session[:intended_uri]
        redirect_uri = session[:intended_uri]
        session[:intended_uri] = nil
        redirect_to redirect_uri
      elsif request.env["HTTP_REFERER"]
        if request.env["HTTP_REFERER"].gsub(request.base_url, "") == root_path
          redirect_to user_path(user)
        else
          redirect_to request.env["HTTP_REFERER"].gsub(request.base_url, "")
        end
      elsif request.env["action_dispatch.request.unsigned_session_cookie"] && request.env["action_dispatch.request.unsigned_session_cookie"]["omniauth.origin"]
        if request.env["action_dispatch.request.unsigned_session_cookie"]["omniauth.origin"].gsub(request.base_url, "") == root_path
          redirect_to user_path(user)
        else
          redirect_to request.env["action_dispatch.request.unsigned_session_cookie"]["omniauth.origin"].gsub(request.base_url, "")
        end
      end
    elsif params[:user][:name].present?
      user = User.find_or_create_by(:name => params[:user][:name])
      if user.save
        session[:user_id] = user.id
        redirect_to user_path(user)
      else
        flash[:notice] = "Sorry, there was a problem signing you in!"
        redirect_to root_path
      end
    end
    if !existing_user && user.persisted?
      UserMailer.welcome_email(user).deliver
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

