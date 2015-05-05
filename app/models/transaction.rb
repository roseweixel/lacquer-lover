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
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  
  before_create :defaults
  after_save :update_associated_user_lacquer
  before_save :set_date_became_active
  before_destroy :set_associated_user_lacquer_on_loan_to_false
  
  validates_presence_of :requester, :user_lacquer, :owner
  validate :transaction_must_be_unique, :on => :create
  validate :user_lacquer_must_be_loanable, :on => :create
  validate :user_lacquer_must_not_be_on_loan, :on => :create
  validate :requester_and_user_must_be_friends, :on => :create
  validate :user_lacquer_must_belong_to_owner, :on => :create
  validate :no_due_date_if_state_is_not_active, :on => :update
  validate :due_date_must_be_in_the_future, :on => :update
  validate :valid_state, :on => [:create, :update]

  SECONDS_PER_DAY = 86400

  STATES = ['pending', 'accepted', 'rejected', 'active', 'returned_unconfirmed', 'completed', 'disputed']

  def update_associated_user_lacquer
    case state
    when 'accepted'
      user_lacquer.update(on_loan: true)
    when 'completed'
      user_lacquer.update(on_loan: false)
    end
  end

  def set_date_became_active
    if state == 'active' && !date_became_active
      date_became_active = Date.today
    end
  end

  def set_associated_user_lacquer_on_loan_to_false
    user_lacquer.update(on_loan: false)
  end

  def defaults
    self.owner_id ||= user_lacquer.user_id
  end

  def valid_state
    if !Transaction::STATES.include?(state)
      errors.add(:transaction, "That is not a valid state for a Transaction!")
    end
  end

  def no_due_date_if_state_is_not_active
    if !['active', 'completed'].include?(self.state) && self.due_date
      errors.add(:transaction, "you can only assign a due date after you've given #{self.lacquer.name} to #{self.requester.first_name}")
    end
  end

  def due_date_must_be_in_the_future
    if self.due_date && self.due_date < Date.today && self.state != 'completed'
      errors.add(:transaction, "the due date must be in the future")
    end
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

  def user_lacquer_must_belong_to_owner
    if user_lacquer.user_id != owner_id
      errors.add(:transaction, "You can only borrow a lacquer from the person who owns it!")
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
      Date.today.to_time.to_i / SECONDS_PER_DAY - due_date.to_time.to_i / SECONDS_PER_DAY
    end
  end

  def state_string
    if state == 'returned_unconfirmed'
      "returned - awaiting confirmation from #{owner.first_name}"
    end
  end
end
