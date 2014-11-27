class LacquersController < ApplicationController
  def index
    @lacquers = Lacquer.all
    @opi_laquers = Lacquer.where(brand: "OPI").first
    @essie_laquers = Lacquer.where(brand: "Essie").first
    @butter_laquers = Lacquer.where(brand: "Butter London").first
    @deborah_laquers = Lacquer.where(brand: "Deborah Lippmann").first
  end
end
