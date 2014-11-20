class User < ActiveRecord::Base
  has_many :user_lacquers
  has_many :lacquers, through: :user_lacquers
end
