class Color < ActiveRecord::Base
  has_many :lacquer_colors
  has_many :lacquers, through: :lacquer_colors
end
