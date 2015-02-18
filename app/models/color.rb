class Color < ActiveRecord::Base
  has_many :user_lacquer_colors
  has_many :user_lacquers, through: :user_lacquer_colors
  has_many :lacquers, through: :user_lacquers

  validates_presence_of :name
end
