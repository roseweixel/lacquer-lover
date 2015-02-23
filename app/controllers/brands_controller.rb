class BrandsController < ApplicationController
  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
    @lacquers = @brand.lacquers
  end

  def lacquer
    @lacquer = Lacquer.find(params[:id])
    @brand = @lacquer.brand
    respond_to do |format|
      format.js { }
    end
  end

  def update
    @user = current_user
    if params[:lacquer_ids]
      params[:lacquer_ids].each do |id|
        UserLacquer.create(lacquer_id: id, user_id: @user.id)
      end
      flash[:notice] = "You've successfully added #{params[:lacquer_ids].count} lacquers to your collection!"
      redirect_to :back
    else
      flash[:alert] = "No lacquers were selected!"
      redirect_to :back
    end
  end
end
