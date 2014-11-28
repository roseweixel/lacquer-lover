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

  def first_name
    name.split.first
  end

  def last_name
    name.split.last
  end
end
