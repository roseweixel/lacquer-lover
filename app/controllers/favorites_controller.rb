class FavoritesController < ApplicationController
  def create
    @current_user = current_user
    @lacquer = Lacquer.find(params[:lacquer_id])
    if params[:user_lacquer_id]
      @user_lacquer = UserLacquer.find(params[:user_lacquer_id])
    end
    @favorite = Favorite.create(user_id: params[:user_id], lacquer_id: params[:lacquer_id])
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
    
  end

  def destroy
    @current_user = current_user
    @lacquer = Lacquer.find(params[:lacquer_id])
    if params[:user_lacquer_id]
      @user_lacquer = UserLacquer.find(params[:user_lacquer_id])
    end
    Favorite.find_by(user_id: params[:user_id], lacquer_id: params[:lacquer_id]).destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { }
    end
  end
end
