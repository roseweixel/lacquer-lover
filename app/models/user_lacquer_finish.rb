class UserLacquerFinish < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :finish
  validates_presence_of :finish, :user_lacquer
end
