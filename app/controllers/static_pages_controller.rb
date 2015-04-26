class StaticPagesController < ApplicationController
  def welcome
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = User.new
    end
  end
end
