class BrandsController < ApplicationController
  def index
    @brands = Brand.all

  end

  def show
    @brand = Brand.find(params[:id])
    @lacquers = @brand.lacquers.paginate(:page => params[:page], :per_page => 20)
  end
end