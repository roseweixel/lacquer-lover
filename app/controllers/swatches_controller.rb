class SwatchesController < ApplicationController
  before_action :set_current_user, only: [:create]

  def create
    @swatch = Swatch.create(swatch_params)
    @swatch.user = @user
    if @swatch.save
      flash[:notice] = "The swatch has been uploaded!"
    else
      flash[:notice] = "This swatch upload was unsuccessful."
    end
    redirect_to :back
  end

  def destroy
    @swatch = Swatch.find(params[:id])
    @lacquer = Lacquer.find(@swatch.lacquer_id)
    @swatch.destroy
    flash[:notice] = "The swatch for #{@lacquer.name} has been deleted."
    redirect_to :back 
  end

  private
  def swatch_params
    params.require(:swatch).permit(:lacquer_id, :image)
  end
end
