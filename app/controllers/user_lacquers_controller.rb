class UserLacquersController < ApplicationController

  def create
    binding.pry
    user_id = current_user.id
    lacquer_id = params["lacquer"]["id"]
    if lacquer_id == "new"
      brand = Brand.find_by(name: params[:lacquer][:brand])
      lacquer = Lacquer.create(brand: brand, name: params[:lacquer][:name], user_added_by_id: params[:lacquer][:user_added_by_id])
    else
      lacquer = Lacquer.find(lacquer_id)
    end
    UserLacquer.create(user_id: user_id, lacquer_id: lacquer.id)
    flash[:notice] = "#{lacquer.name} has been added to your collection!"
    redirect_to(:back)
  end

  def update
    #binding.pry
    @user_lacquer = UserLacquer.find(params[:id])
    @user_lacquer.update(user_lacquer_params)
    redirect_to(:back)
  end

  def destroy
    #binding.pry
    user_lacquer = UserLacquer.where(user_id: params['user_id'], lacquer_id: params['lacquer_id']).first
    if params['user_id'].to_i == current_user.id
      user_lacquer.destroy
      redirect_to(:back)
    else
      flash[:notice] = "You can't delete another user's lacquer!"
      redirect_to(:back)
    end
  end

  private
    def user_lacquer_params
      params.require(:user_lacquer).permit(:loanable, :on_loan)
    end
end
