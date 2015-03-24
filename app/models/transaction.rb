# == Schema Information
#
# Table name: transactions
#
#  id                 :integer          not null, primary key
#  user_lacquer_id    :integer
#  requester_id       :integer
#  type               :string(255)
#  date_ended         :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  state              :string(255)
#  owner_id           :integer
#  due_date           :datetime
#  date_became_active :datetime
#

class Transaction < ActiveRecord::Base
  belongs_to :user_lacquer
  delegate :lacquer, to: :user_lacquer
  delegate :user, to: :user_lacquer
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  #belongs_to :user, through: :user_lacquer, dependent: :destroy
  before_create :defaults
  validates_presence_of :requester, :user_lacquer, :owner

  validate :transaction_must_be_unique, :on => :create
  validate :user_lacquer_must_be_loanable, :on => :create
  validate :user_lacquer_must_not_be_on_loan, :on => :create
  validate :requester_and_user_must_be_friends, :on => :create

  SECONDS_PER_DAY = 86400

  def defaults
    self.owner_id ||= user_lacquer.user_id
    self.state ||= 'pending'
    # self.type ||= 'Loan'
  end

  def owner
    User.find(user_lacquer.user_id)
  end


  def transaction_must_be_unique
    if !Transaction.where(:user_lacquer_id => user_lacquer_id, :requester_id => requester_id, :state => ['pending', 'accepted', 'active', 'rejected']).empty?
      errors.add(:transaction, "This request already exists!")
    end
  end

  def requester_and_user_must_be_friends
    if !User.find(user_lacquer.user_id).accepted_friends.include?(requester)
      errors.add(:transaction, "You must be friends with the person you would like a transaction with!")
    end
  end

  def user_lacquer_must_be_loanable
    if !user_lacquer.loanable
      errors.add(:transaction, "The owner of this lacquer has not made it loanable!")
    end
  end

  def user_lacquer_must_not_be_on_loan
    if user_lacquer.on_loan
      errors.add(:transaction, "This lacquer is already on loan.")
    end
  end

  def due_today?
    due_date.to_date == Date.today
  end

  def due_tomorrow?
    due_date.to_date - 1 == Date.today
  end

  def overdue?
    due_date.to_date < Date.today
  end

  def days_overdue
    if overdue?
      Date.today.to_time.to_i / SECONDS_PER_DAY - Transaction.last.due_date.to_time.to_i / SECONDS_PER_DAY
    end
  end
end
