class FriendshipsController < ApplicationController
  def new
    @user = current_user
    if params[:friend_id]
      @friend = User.find(params[:friend_id])
      @friendship = current_user.friendships.new(friend: @friend)
    else
      flash[:error] = "Friend required"
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Friend Not Found"
    redirect_to(:back)
  end

  def create
    @user = current_user
    Friendship.create(friend_id: params[:friendship][:friend_id], user_id: params[:friendship][:user_id])
    redirect_to(:back)
  end

  def destroy
    @user = current_user
  end
end
