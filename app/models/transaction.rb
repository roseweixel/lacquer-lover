class Transaction < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'

  validate :transaction_must_be_unique, :on => :create

  def owner
    User.find(user_lacquer.user_id)
  end

  def transaction_must_be_unique
    if !Transaction.where(:user_lacquer_id => user_lacquer_id, :requester_id => requester_id).empty?
      errors.add(:transaction, "This request already exists!")
    end
  end
end
