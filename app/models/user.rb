# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  provider         :string(255)
#  uid              :string(255)
#  name             :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  email            :string(255)
#  image            :string(255)
#

class User < ActiveRecord::Base
  has_many :user_lacquers, -> { order(:updated_at => :desc) }, dependent: :destroy
  has_many :lacquers, through: :user_lacquers
  has_many :brands, -> { uniq }, through: :lacquers
  
  has_many :friendships, dependent: :destroy
  has_many :friendships_initiated_by_others, class_name: 'Friendship', :foreign_key => "friend_id", dependent: :destroy
  has_many :friends, through: :friendships
  has_many :follower_friends, through: :friendships_initiated_by_others
  
  has_many :requested_transactions, class_name: 'Transaction', :foreign_key => "requester_id", dependent: :destroy
  has_many :owned_transactions, class_name: 'Transaction', :foreign_key => "owner_id"
  has_many :requested_gifts, class_name: 'Gift', :foreign_key => "requester_id"
  has_many :owned_gifts, class_name: 'Gift', :foreign_key => "owner_id"
  has_many :swatches, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :logins

  validates_presence_of :name, :provider, :uid, :oauth_token
  validates_format_of :email, with: /@/, message: "Must be an email", allow_blank: true

  def transactions_and_friendships_data_array
    all_friendships.pluck(:state) + transactions.pluck(:state)
  end

  def all_friendships
    friendships + friendships_initiated_by_others
  end

  def all_friends
    friends + follower_friends
  end

  def lacquer_gifts_given
    owned_gifts.where(state: ['completed', 'acknowledged'])
  end

  def lacquer_gifts_received
    requested_gifts.where(state: ['completed', 'acknowledged'])
  end

  def lacquer_gifts_received_not_acknowledged
    requested_gifts.where(state: ['completed'])
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def first_name
    name.split.first
  end

  def accepted_friends
    ids = Friendship.where(user_id: self.id, state: 'accepted').pluck(:friend_id) + Friendship.where(friend_id: self.id, state: 'accepted').pluck(:user_id)
    User.where(id: ids)
  end

  def accpeted_friendships_you_requested
    Friendship.where(user_id: self.id, state: 'accepted')
  end

  def accepted_friendships_you_accepted
    Friendship.where(friend_id: self.id, state: 'accepted')
  end

  def all_accepted_friendships
    accpeted_friendships_you_requested + accepted_friendships_you_accepted
  end

  def requested_friends_awaiting_approval
    pending_friends = []
    Friendship.where(user_id: self.id, state: 'pending').each do |friendship|
      pending_friends << User.find(friendship.friend_id)
    end
    pending_friends
  end

  def requested_friendships_awaiting_approval
    Friendship.includes(:friend).where(user_id: self.id, state: 'pending')
  end

  def rejected_friend_requests
    Friendship.includes(:friend).where(user_id: self.id, state: 'rejected')
  end

  def friendships_for_your_approval
    Friendship.includes(:user).where(friend_id: self.id, state: 'pending')
  end

  def friends_for_your_approval
    pending_friends = []
    Friendship.where(friend_id: self.id, state: 'pending').each do |friendship|
      friend = User.find(friendship.user_id)
      pending_friends << friend
    end
    pending_friends
  end

  def all_friends
    accepted_friends + requested_friends_awaiting_approval + friends_for_your_approval
  end

  def pending_requested_transactions
    requested_transactions.where(state: 'pending')
  end

  def rejected_requested_transactions
    requested_transactions.where(state: 'rejected')
  end

  def accepted_requested_transactions
    requested_transactions.where(state: 'accepted')
  end

  def active_requested_transactions
    requested_transactions.where(state: 'active')
  end

  def concluded_requested_transactions
    requested_transactions.where(state: 'completed')
  end

  def transactions_for_your_approval
    owned_transactions.where(state: 'pending')
  end

  def transactions_you_accepted
    owned_transactions.where(state: 'accepted')
  end

  def active_owned_transactions
    owned_transactions.where(state: 'active')
  end

  def requested_returned_unconfirmed_transactions
    requested_transactions.where(state: 'returned_unconfirmed')
  end

  def owned_returned_unconfirmed_transactions
    owned_transactions.where(state: 'returned_unconfirmed')
  end

  def disputed_transactions
    Transaction.where("(owner_id = #{id} OR requester_id = #{id}) AND state = 'disputed'")
  end

  def owned_disputed_transactions
    owned_transactions.where(state: 'disputed')
  end

  def requested_disputed_transactions
    requested_transactions.where(state: 'disputed')
  end

  def concluded_owned_transactions
    owned_transactions.where(state: 'completed')
  end

  def lacquers_added_by
    Lacquer.where(user_added_by_id: self.id)
  end

  def user_lacquers_sorted_by(attribute="updated_at")
    if attribute == "updated_at"
      user_lacquers.sort{ |a,b| b.updated_at <=> a.updated_at }
    else
      user_lacquers.sort_by{ |l| l.send(attribute) }
    end
  end

  def favorited_lacquers
    favorite_lacquers_ids = favorites.pluck(:lacquer_id)
    Lacquer.where(id: favorite_lacquers_ids)
  end

end
