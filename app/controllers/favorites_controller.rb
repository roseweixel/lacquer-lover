class FavoritesController < ApplicationController
  before_action :set_current_user
  
  def create
    @lacquer = Lacquer.find(params[:lacquer_id])
    if params[:user_lacquer_id]
      @user_lacquer = UserLacquer.find(params[:user_lacquer_id])
    end
    @favorite = Favorite.create(user_id: params[:user_id], lacquer_id: params[:lacquer_id])
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @lacquer = Lacquer.find(params[:lacquer_id])
    if params[:user_lacquer_id]
      @user_lacquer = UserLacquer.find(params[:user_lacquer_id])
    end
    Favorite.find_by(user_id: params[:user_id], lacquer_id: params[:lacquer_id]).destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
