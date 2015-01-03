class UsersController < ApplicationController
  # def create
  #   User.create(name: params[:name])
  # end

  def index
    if current_user
      @user = current_user
      @users = User.all
    else
      flash[:notice] = "Please sign in to continue!"
      redirect_to root_path
    end
  end

  # def load_notifications
  #   @user = current_user
  #   @user.class.load_notifications
  # end

  def show
    if current_user
      if !Brand.where(name: "OPI").empty?
        @new_opi_lacquer = Brand.where(name: "OPI").first.lacquers.new
        @opi_lacquers = Brand.where(name: "OPI").first.lacquers        
      end
      if !Brand.where(name: "Essie").empty?
        @new_essie_lacquer = Brand.where(name: "Essie").first.lacquers.new
        @essie_lacquers = Brand.where(name: "Essie").first.lacquers
      end
      if !Brand.where(name: "Butter London").empty?
        @new_butter_lacquer = Brand.where(name: "Butter London").first.lacquers.new 
        @butter_lacquers = Brand.where(name: "Butter London").first.lacquers
      end
      if !Brand.where(name: "Deborah Lippmann").empty?
        @new_deborah_lacquer = Brand.where(name: "Deborah Lippmann").first.lacquers.new 
        @deborah_lacquers = Brand.where(name: "Deborah Lippmann").first.lacquers
      end
      @new_user_lacquer = UserLacquer.new
      @user = User.find(params[:id])
      @transactions = @user.transactions
      @friends = @user.friends
      @friendship = current_user.friendships.new(friend: @user)
      @transaction = Transaction.new
      @user_lacquers = @user.user_lacquers.paginate(:page => params[:page], :per_page => 5)
      respond_to do |format|
        format.js
        format.html
      end
    else
      flash[:notice] = "Please sign in to continue!"
      redirect_to root_path
    end
  end
end
