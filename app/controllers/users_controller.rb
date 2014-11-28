class UsersController < ApplicationController
  # def create
  #   User.create(name: params[:name])
  # end
  def index
    @hello = 'hello'
  end

  def show
    @user = current_user
  end
end
