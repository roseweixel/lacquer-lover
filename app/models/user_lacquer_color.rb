class UserLacquerColor < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :color
  validates_presence_of :color, :user_lacquer
end