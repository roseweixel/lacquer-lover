class SessionsController < ApplicationController
  def create
    if params[:username].present?
      user = User.find_by(:username => params[:username])
      if user
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash[:notice] = "Could not find that person, sorry!"
        redirect_to root_path
      end
    elsif request.env['omniauth.auth'].present?
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_path
    end
    
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
