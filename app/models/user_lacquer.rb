class UserLacquer < ActiveRecord::Base
  belongs_to :user
  belongs_to :lacquer
end
