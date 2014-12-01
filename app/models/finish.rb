class Finish < ActiveRecord::Base
  has_many :user_lacquer_finishes
  has_many :user_lacquers, through: :user_lacquer_finishes
  has_many :lacquers, through: :user_lacquers
end