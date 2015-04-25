class GiftsController < ApplicationController
  def create
    @gift = Gift.create(gift_params)

    @gift.transfer_user_lacquer_from_owner_to_requester if @gift.state == 'completed'

    respond_to do |f|
      f.html { redirect_to :back }
      f.js { }
    end
  end

  def gift_params
    params.require(:gift).permit(:user_lacquer_id, :requester_id, :owner_id, :state)
  end
end
