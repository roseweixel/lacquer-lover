class FriendshipsController < ApplicationController
  def new
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
  end

  def destroy
  end
end
