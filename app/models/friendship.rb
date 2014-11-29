class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  def user
    User.find(self[:user_id])
  end

  def friend
    User.find(self[:friend_id])
  end

  
end
