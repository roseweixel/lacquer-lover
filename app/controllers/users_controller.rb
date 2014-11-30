class UsersController < ApplicationController
  # def create
  #   User.create(name: params[:name])
  # end

  def index
    @user = current_user
    @users = User.all
  end

  def show
    @new_opi_lacquer = Brand.where(name: "OPI").first.lacquers.new
    @new_essie_lacquer = Brand.where(name: "Essie").first.lacquers.new
    @new_butter_lacquer = Brand.where(name: "Butter London").first.lacquers.new
    @new_deborah_lacquer = Brand.where(name: "Deborah Lippmann").first.lacquers.new
    @new_user_lacquer = UserLacquer.new
    @opi_lacquers = Brand.where(name: "OPI").first.lacquers
    @essie_lacquers = Brand.where(name: "Essie").first.lacquers
    @butter_lacquers = Brand.where(name: "Butter London").first.lacquers
    @deborah_lacquers = Brand.where(name: "Deborah Lippmann").first.lacquers
    @user = User.find(params[:id])
    @friendship = current_user.friendships.new(friend: @user)
    @transaction = Transaction.new
  end
end
