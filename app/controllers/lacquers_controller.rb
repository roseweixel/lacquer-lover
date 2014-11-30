class LacquersController < ApplicationController
  def index
    @lacquer = Lacquer.new
    @user_lacquer = UserLacquer.new
    @opi_lacquers = Brand.where(name: "OPI").first.lacquers
    @essie_lacquers = Brand.where(name: "Essie").first.lacquers
    @butter_lacquers = Brand.where(name: "Butter London").first.lacquers
    @deborah_lacquers = Brand.where(name: "Deborah Lippmann").first.lacquers
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = User.new
    end
  end

  def create
    lacquer = Lacquer.create(name: params[:lacquer][:name], brand_id: params[:lacquer][:brand_id], user_added_by_id: params[:lacquer][:user_added_by_id])
    if !lacquer.save
      lacquer.errors.messages.each do |message|
        flash[:notice] = message
      end
    else
      params[:lacquer][:color_ids].each do |color_id|
        if color_id != ""
          lacquer.lacquer_colors.create(color_id: color_id)
        end
      end
      params[:lacquer][:finish_ids].each do |finish_id|
        if finish_id != ""
          lacquer.lacquer_finishes.create(finish_id: finish_id)
        end
      end
      if params[:user_id]
        lacquer.user_lacquers.create(user_id: params[:user_id])
      end
    end
    redirect_to(:back)
  end

  def show
    @lacquer = Lacquer.find(params[:id])
  end

  def edit
    @lacquer = Lacquer.find(params[:id])
    @swatch = Swatch.new
  end

  def update
    #binding.pry
    @user = current_user
    @lacquer = Lacquer.find(params[:id])
    @lacquer.update(lacquer_params)
    redirect_to(:back)
  end

  private
    def lacquer_params
      params.require(:lacquer).permit(:name, :brand_id, :color_ids => [], :finish_ids => [], :swatches_attributes => [:image, :user_id, :delete_image])
    end

end
