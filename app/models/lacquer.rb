class Lacquer < ActiveRecord::Base
  belongs_to :brand
  has_many :lacquer_colors
  has_many :colors, through: :lacquer_colors
  has_many :lacquer_finishes
  has_many :finishes, through: :lacquer_finishes
  has_many :user_lacquers
  has_many :users, through: :user_lacquers
end
