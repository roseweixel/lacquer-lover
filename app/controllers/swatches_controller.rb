class SwatchesController < ApplicationController
  def index
    @swatches = Swatch.all
  end

  def new

    @user = current_user
    @swatch = Swatch.new
  end

  def create
    @user = current_user
    @swatch = Swatch.create(swatch_params)
    if @swatch.save
      flash[:notice] = "The swatch has been uploaded!"
    else
      flash[:notice] = "This swatch upload was unsuccessful."
    end
    redirect_to(:back)
  end

  def destroy
    @swatch = Swatch.find(params[:id])
    @lacquer = Lacquer.find(@swatch.lacquer_id)
    @swatch.destroy
    flash[:notice] = "The swatch for #{@lacquer.name} has been deleted."
    redirect_to(:back) 
  end

  private
  def swatch_params
    params.require(:swatch).permit(:user_id, :lacquer_id, :image)
  end
end
