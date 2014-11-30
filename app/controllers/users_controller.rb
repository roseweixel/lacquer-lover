class UsersController < ApplicationController
  # def create
  #   User.create(name: params[:name])
  # end

  def index
    @user = current_user
    @users = User.all
  end

  def show
    @new_lacquer = Lacquer.new
    @new_user_lacquer = UserLacquer.new
    @color_1 = Color.new(name: "new1")
    @finish_1 = Finish.new(description: "new1")
    @color_2 = Color.new(name: "new2")
    @finish_2 = Finish.new(description: "new2")
    @opi_lacquers = Brand.where(name: "OPI").first.lacquers
    @essie_lacquers = Brand.where(name: "Essie").first.lacquers
    @butter_lacquers = Brand.where(name: "Butter London").first.lacquers
    @deborah_lacquers = Brand.where(name: "Deborah Lippmann").first.lacquers
    @user = User.find(params[:id])
    @friendship = current_user.friendships.new(friend: @user)
    @transaction = Transaction.new
  end
end
