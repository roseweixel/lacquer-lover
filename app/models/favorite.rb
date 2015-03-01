class Favorite < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :user
end
