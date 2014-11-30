class FriendshipsController < ApplicationController
  def new
    @user = current_user
    @friend = User.find(params[:friend_id])
    if params[:friend_id]
      @friend = User.find(params[:friend_id])
      @friendship = current_user.friendships.new(friend: @friend)
    else
      flash[:notice] = "Friend required"
    end
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "Friend Not Found"
    redirect_to root_path
  end

  def create
    @user = current_user
    if params[:friendship] && params[:friendship].has_key?(:friend_id)
      @friend = User.find(params[:friendship][:friend_id])
      @friendship = Friendship.new(friend: @friend, user: @user, state: 'pending')
      @friendship.save
      flash[:notice] = "Your friendship with #{@friend.name} is pending."
      redirect_to(:back)
    else
      flash[:notice] = "Friend required"
      redirect_to root_path
    end
  end

  def update
    @friendship = Friendship.find(params[:id])
    @friendship.update(state: params[:state])
    redirect_to(:back)
  end

  def destroy
    @user = current_user
  end
end
