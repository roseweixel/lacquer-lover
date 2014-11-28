class UserLacquersController < ApplicationController

  def create
    user_id = current_user.id
    lacquer_id = params["lacquer"]["id"]
    lacquer = Lacquer.find(lacquer_id)
    UserLacquer.create(user_id: user_id, lacquer_id: lacquer_id)
    flash[:notice] = "#{lacquer.name} has been added to your collection!"
    redirect_to(:back)
  end

  def destroy
    user_lacquer = UserLacquer.where(user_id: params['user_id'], lacquer_id: params['lacquer_id']).first
    user_lacquer.destroy
    redirect_to(:back)
  end
end