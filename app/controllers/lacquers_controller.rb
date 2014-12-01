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
    #binding.pry
    user = current_user
    lacquer = Lacquer.create(name: params[:lacquer][:name], brand_id: params[:lacquer][:brand_id], user_added_by_id: params[:lacquer][:user_added_by_id])
    if !lacquer.save
      lacquer.errors.messages.each do |message|
        flash[:notice] = message
      end
    else
      if params[:user_lacquer]
        user_lacquer = lacquer.user_lacquers.create(user_id: current_user.id)
        params[:user_lacquer][:color_ids].each do |color_id|
          if color_id != ""
            user_lacquer.colors.push(Color.find(color_id))
          end
        end
        params[:user_lacquer][:finish_ids].each do |finish_id|
          if finish_id != ""
            user_lacquer.finishes.push(Finish.find(finish_id))
          end
        end
      end
    end
    redirect_to(:back)
  end

  def show
    @lacquer = Lacquer.find(params[:id])
  end

  def edit
    #binding.pry
    @user = current_user
    @lacquer = Lacquer.find(params[:id])
    @user_lacquer = UserLacquer.find(params[:user_lacquer_id])
    session[:user_lacquer_id] = params[:user_lacquer_id]
    @swatch = Swatch.new
  end

  def update
    #binding.pry
    @user = current_user
    @lacquer = Lacquer.find(params[:id])
    @user_lacquer = UserLacquer.find(session[:user_lacquer_id])
    @lacquer.update(lacquer_params)
    if params[:lacquer][:user_lacquer][:color_ids]
      @user_lacquer.colors.clear
      params[:lacquer][:user_lacquer][:color_ids].each do |color_id|
        if color_id != ""
          @user_lacquer.colors.push(Color.find(color_id))
        end
      end
    end
    if params[:lacquer][:user_lacquer][:finish_ids]
      @user_lacquer.finishes.clear
      params[:lacquer][:user_lacquer][:finish_ids].each do |finish_id|
        if finish_id != ""
          @user_lacquer.finishes.push(Finish.find(finish_id))
        end
      end
    end
    flash[:notice] = "#{@lacquer.name} successfully updated!"
    redirect_to(:back)
  end

  private
    def lacquer_params
      params.require(:lacquer).permit(:name, :brand_id, :swatches_attributes => [:image, :user_id, :delete_image])
    end


end
