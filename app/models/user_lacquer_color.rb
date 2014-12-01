class UserLacquerColor < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :color
end