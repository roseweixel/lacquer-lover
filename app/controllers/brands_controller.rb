class BrandsController < ApplicationController
  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
    @lacquers = @brand.lacquers
    @user = current_user
  end

  def lacquer
    @lacquer = Lacquer.find(params[:id])
    @brand = @lacquer.brand
    @user = current_user
    respond_to do |format|
      format.js { }
    end
  end

  def update
    @user = current_user
    if params[:lacquer_ids]
      @lacquer_ids = params[:lacquer_ids]
      @lacquer_count = params[:lacquer_ids].count
      params[:lacquer_ids].each do |id|
        UserLacquer.create(lacquer_id: id, user_id: @user.id)
      end
    else
      flash[:alert] = "No lacquers were selected!"
      redirect_to :back
    end
    respond_to do |format|
      format.html {
        flash[:notice] = "You've successfully added #{params[:lacquer_ids].count} lacquers to your collection!"
        redirect_to :back
      }
      format.js { }
    end
  end
end
