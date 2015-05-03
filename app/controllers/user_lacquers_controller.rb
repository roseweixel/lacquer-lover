class UserLacquersController < ApplicationController

  def create
    @user_lacquer = UserLacquer.create(user_lacquer_params)
    @user = current_user
    @favorite = Favorite.find_by(user_id: current_user.id, lacquer_id: @user_lacquer.lacquer.id)
    respond_to do |format|
      format.html { 
        flash[:notice] = "#{lacquer.name} has been added to your collection!"
        redirect_to(:back)
      }
      format.js { }
    end
  end

  def update
    @user_lacquer = UserLacquer.find(params[:id])
    if current_user == User.find(@user_lacquer.user_id)
      @user_lacquer.update(user_lacquer_params)
      if @user_lacquer.on_loan == false
        @user_lacquer.transactions.clear
        @user_lacquer.save
      end
    else
      flash[:alert] = "You are trying to update a lacquer that is not yours!"
    end
    respond_to do |format|
      format.js { }
    end
  end

  def destroy
    @user_lacquer = UserLacquer.find(params[:id])
    user = User.find(@user_lacquer.user_id)
    @lacquer = Lacquer.find(@user_lacquer.lacquer_id)
    if user == current_user
      @user_lacquer.destroy
      if !@user_lacquer.errors.empty? || !@user_lacquer.destroy
        flash[:notice] = "There was an error deleting this lacquer!"
        redirect_to :back
      else
        respond_to do |format|
          format.html { redirect_to :back }
          format.js { }
        end
      end
    else
      flash[:notice] = "You can't delete another user's lacquer!"
      redirect_to(:back)
    end
  end

  def random
    @user = current_user
    @lacquer = @user.lacquers.sample
  end

  private
    def user_lacquer_params
      params.require(:user_lacquer).permit(:user_id, :lacquer_id, :loanable, :on_loan, :giftable, :color_ids => [], :finish_ids => [])
    end
end
