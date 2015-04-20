class FriendshipsController < ApplicationController
  def new
    @user = current_user
    if !@user && request.env['REQUEST_URI']
      if request.env['REQUEST_URI'].scan(/(?<=friend_id=)\d+/)[0]
        session[:intended_uri] = request.env['REQUEST_URI']
        @friend = User.find("#{session[:intended_uri].scan(/(?<=friend_id=)\d+/)[0]}")
        flash[:notice] = %Q[ Sign in to #{view_context.link_to("join #{@friend.name}'s lacquer sharing network", login_path, id:"brand-show-sign-in", class:'light-blue-link')}! ]
        flash[:html_safe] = true
        redirect_to root_path and return true
      else
        flash[:notice] = "Sign in to add friends to your network!"
        redirect_to root_path and return true
      end
    end
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
      if @friendship.save
        UserMailer.friend_request_notification(@user, @friend).deliver_now
        flash[:notice] = "Your friendship with #{@friend.name} is pending and a notification has been sent."
      else
        flash[:alert] = "There was an error creating this friendship!"
      end
      redirect_to(:back)
    else
      flash[:notice] = "Friend required"
      redirect_to root_path
    end
  end

  def update
    begin
      @friendship = Friendship.find(params[:id])
      @friendship.update(state: params[:state])
    rescue
      flash[:alert] = "Sorry, we can't seem to find the friendship you were trying to update!"
    end
    if @friendship.state == "accepted"
      flash[:success] = "Congratulations, you are now friends with #{@friendship.user.name}! You can now view each other's collections and borrow lacquers from each other."
      UserMailer.friend_request_accepted_notification(@friendship.user, @friendship.friend).deliver_now
      redirect_to user_path(@friendship.user)
    elsif @friendship.state == "rejected"
      flash[:alert] = "You have rejected #{@friendship.user.name}'s friend request."
      redirect_to user_path(current_user)
    else
      flash[:notice] = "This friendship is now #{params[:state]}."
      redirect_to(:back)
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    if @friendship.state == 'pending' && current_user == @friendship.user
      @friendship.destroy
      flash[:notice] = "Pending request deleted."
      redirect_to(:back)
    else
      flash[:alert] = "This request could not be deleted!"
      redirect_to(:back)
    end
  end
end
