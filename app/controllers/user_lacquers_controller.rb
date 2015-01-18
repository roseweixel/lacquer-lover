class UserLacquersController < ApplicationController

  def create
    lacquer = Lacquer.find(params[:user_lacquer][:lacquer_id])
    UserLacquer.create(user_lacquer_params)
    flash[:notice] = "#{lacquer.name} has been added to your collection!"
    redirect_to(:back)
  end

  def update
    #binding.pry
    @user_lacquer = UserLacquer.find(params[:id])
    if current_user == User.find(@user_lacquer.user_id)
      @user_lacquer.update(user_lacquer_params)
      if @user_lacquer.on_loan == false
        @user_lacquer.transactions.clear
        @user_lacquer.save
      end
      flash[:notice] = "#{Lacquer.find(@user_lacquer.lacquer_id).name} successfully updated!"
    else
      flash[:alert] = "You are trying to update a lacquer that is not yours!"
    end
    #binding.pry
    redirect_to(:back)
  end

  def destroy
    #binding.pry
    user_lacquer = UserLacquer.find(params[:id])
    #user_lacquer = UserLacquer.where(user_id: params['user_id'], lacquer_id: params['lacquer_id']).first
    user = User.find(user_lacquer.user_id)
    if user == current_user
      user_lacquer.destroy
      if !user_lacquer.errors.empty? || !user_lacquer.destroy
        flash[:notice] = "There was an error deleting this lacquer!"
      end
      redirect_to(:back)
    else
      flash[:notice] = "You can't delete another user's lacquer!"
      redirect_to(:back)
    end
  end

  private
    def user_lacquer_params
      params.require(:user_lacquer).permit(:user_id, :lacquer_id, :loanable, :on_loan)
    end
end
