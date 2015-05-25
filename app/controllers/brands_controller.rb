class BrandsController < ApplicationController
  before_action :set_current_user, except: [:index]

  def index
    @brands = Brand.includes(:lacquers, :favorites, :users).all
  end

  def show
    @brand = Brand.includes(:lacquers).order('lacquers.name').find(params[:id])
  end

  def lacquer
    @lacquer = Lacquer.find(params[:id])
    @brand = @lacquer.brand
    @user ? User.includes(:lacquers).find(current_user.id) : nil
    respond_to do |format|
      format.js
    end
  end

  def update
    if @lacquer_ids = params[:lacquer_ids]
      @lacquer_ids.each do |id|
        UserLacquer.create(lacquer_id: id, user_id: @user.id)
      end
    else
      flash[:alert] = "No lacquers were selected!"
      redirect_to :back
    end
    respond_to do |format|
      format.html {
        flash[:notice] = "You've successfully added #{@lacquer_ids.count} lacquers to your collection!"
        redirect_to :back
      }
      format.js
    end
  end
end
