class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validate :is_not_duplicate, :on => :create

  def user
    User.find(self[:user_id])
  end

  def friend
    User.find(self[:friend_id])
  end

  def is_not_duplicate
    if !(Friendship.where(:friend_id => friend_id, :user_id => user_id).empty? && Friendship.where(:user_id => friend_id, :friend_id => user_id).empty?)
      errors.add(:friendship, "This friendship already exists!")
    end
  end

  
end
