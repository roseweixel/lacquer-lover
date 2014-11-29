class User < ActiveRecord::Base
  has_many :user_lacquers
  has_many :lacquers, through: :user_lacquers
  has_many :friendships
  has_many :friends, through: :friendships


  validates :name, presence: true, uniqueness: true
  #accepts_nested_attributes_for :user_lacquers

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def accepted_friends
    accepted_friends = []
    Friendship.where(user_id: self.id, state: 'accepted').each do |friendship|
      accepted_friends << User.find(friendship.friend_id)
    end
    Friendship.where(friend_id: self.id, state: 'accepted').each do |friendship|
      accepted_friends << User.find(friendship.user_id)
    end
    accepted_friends
  end

  def requested_friends_awaiting_approval
    pending_friends = []
    Friendship.where(user_id: self.id, state: 'pending').each do |friendship|
      pending_friends << User.find(friendship.friend_id)
    end
    pending_friends
  end

  def friends_for_your_approval
    pending_friendships = []
    Friendship.where(friend_id: self.id, state: 'pending').each do |friendship|
      pending_friendships << friendship
    end
    pending_friendships
  end

  def first_name
    name.split.first
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end

  def last_name
    name.split.last
  end
end
