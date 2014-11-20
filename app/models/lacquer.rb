class Lacquer < ActiveRecord::Base
  has_many :user_lacquers
  has_many :users, through: :user_lacquers
end
