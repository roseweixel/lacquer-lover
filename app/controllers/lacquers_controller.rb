class LacquersController < ApplicationController
  def index
    @lacquers = Lacquer.all
  end
end
