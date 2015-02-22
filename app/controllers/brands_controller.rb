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
end
