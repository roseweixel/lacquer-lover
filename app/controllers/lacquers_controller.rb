class LacquersController < ApplicationController
  def index
    @lacquer = Lacquer.new
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
end
