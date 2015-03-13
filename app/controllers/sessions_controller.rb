class SessionsController < ApplicationController
  def create
    if request.env['omniauth.auth'].present?
      user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      #binding.pry
      if request.env["HTTP_REFERER"].gsub(request.base_url, "") == root_path
        redirect_to user_path(user)
      else
        redirect_to request.env["HTTP_REFERER"].gsub(request.base_url, "")
      end
    elsif params[:user][:name].present?
      user = User.find_by(:name => params[:user][:name]) || User.create(:name => params[:user][:name])
      if user
        session[:user_id] = user.id
        redirect_to user_path(user)
      else
        flash[:notice] = "Could not find that person, sorry!"
        redirect_to root_path
      end
    end
    
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

