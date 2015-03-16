# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validate :is_not_duplicate, :on => :create
  validate :is_not_self, :on => :create
  #validates_uniqueness_of :buddy_one, scope: :buddy_two

  def user
    User.find(self[:user_id])
  end

  def friend
    User.find(self[:friend_id])
  end

  def is_not_duplicate
    if !(Friendship.where(:friend_id => friend_id, :user_id => user_id, :state => ["pending", "accepted", "rejected"]).empty? && Friendship.where(:user_id => friend_id, :friend_id => user_id, :state => ["pending", "accepted", "rejected"]).empty?)
      errors.add(:friendship, "This friendship already exists!")
    end
  end

  def is_not_self
    if user_id == friend_id
      errors.add(:friendship, "You cannot friend yourself!")
    end
  end

  
end
