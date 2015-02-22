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

  def live_notifications
    #binding.pry
    @user = current_user
    respond_to do |format|
      format.js { }
    end
  end

  def show
    if current_user
      [{"OPI" => [@new_opi_lacquer, @opi_lacquers]}, {"Essie" => [@new_essie_lacquer, @essie_lacquers]}, {"Butter London" => [@new_butter_lacquer, @butter_lacquers]}, {"Deborah Lippmann" => [@new_deborah_lacquer, @deborah_lacquers]}].each do |brand_hash|
        brand_hash.each do |brand, variables|
          if !Brand.where(name: brand).empty?
            variables[0] = Brand.where(name: brand).first.lacquers.new
            variables[1] = Brand.where(name: brand).first.lacquers        
          end
        end
      end
      @new_user_lacquer = UserLacquer.new
      @user = User.find(params[:id])
      @transactions = @user.transactions
      @friends = @user.friends
      @friendship = current_user.friendships.new(friend: @user)
      @transaction = Transaction.new
      #binding.pry
      @user_lacquers = @user.user_lacquers.paginate(:page => params[:page], :per_page => 5)
      respond_to do |format|
        format.js
        format.html
        format.json
      end
    else
      # temporary for testing purposes!
      @user = User.find(params[:id])
      respond_to do |format|
        format.json
        format.html do
          flash[:notice] = "Please sign in to continue!"
          redirect_to root_path
        end
      end
    end
  end
end
