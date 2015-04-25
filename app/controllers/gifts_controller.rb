class GiftsController < ApplicationController
  def create
    @gift = Gift.create(gift_params)

    if @gift.state == 'completed'
      @gift.transfer_user_lacquer_from_owner_to_requester
      @gift.update(date_completed: Time.now)
      UserMailer.gift_notification(@gift).deliver_now if @gift.requester.email
    end 

    respond_to do |f|
      f.html { redirect_to :back }
      f.js { }
    end
  end

  def update
    @gift = Gift.find(params[:id])
    completed_already? = (@gift.state == 'completed')
    @gift.update(gift_params)
    if !completed_already? && @gift.state == 'completed'
      @gift.update(date_completed: Time.now)
      UserMailer.gift_notification(@gift).deliver_now if @gift.requester.email
    end
    if ['acknowledged', 'completed'].include?(@gift.state) && @gift.requester == current_user
      flash[:success] = "#{@gift.lacquer.name} is now in your collection!"
    end
    redirect_to(:back)
  end

  private
    def gift_params
      params.require(:gift).permit(:user_lacquer_id, :requester_id, :owner_id, :state)
    end
end
