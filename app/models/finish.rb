class Finish < ActiveRecord::Base
  has_many :lacquer_finishes
  has_many :lacquers, through: :lacquer_finishes
end
