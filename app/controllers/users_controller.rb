class UsersController < ApplicationController
  # def create
  #   User.create(name: params[:name])
  # end

  def index
    @user = current_user
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @friendship = current_user.friendships.new(friend: @user)
    @transaction = Transaction.new
  end
end
