class LacquersController < ApplicationController
  def index
    @lacquer = Lacquer.new
    @opi_lacquers = Lacquer.where(brand: "OPI").first
    @essie_lacquers = Lacquer.where(brand: "Essie").first
    @butter_lacquers = Lacquer.where(brand: "Butter London").first
    @deborah_lacquers = Lacquer.where(brand: "Deborah Lippmann").first
  end
end
