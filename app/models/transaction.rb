class Transaction < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  #belongs_to :user, through: :user_lacquer, dependent: :destroy
  validate :transaction_must_be_unique, :on => :create
  
  # Make it possible for users to 
  # 0) reject transactions (and friendships, too!)
        # - not right now
        # - never
        # - ignore?
  # 1) gift a polish after it's been loaned
  # 2) remove a polish while a loan request is pending and automatically notify the requester
  # 3) have a way of polishes "dying" while on loan (i lost it, the dog ate it, i used it up, etc.)
  # 4) have a way of gifting, not just loaning

  SECONDS_PER_DAY = 86400

  def owner
    User.find(user_lacquer.user_id)
  end

  def transaction_must_be_unique
    if !Transaction.where(:user_lacquer_id => user_lacquer_id, :requester_id => requester_id, :state => ['pending', 'accepted', 'active']).empty?
      errors.add(:transaction, "This request already exists!")
    end
  end

  def due_today?
    due_date == Date.today
  end

  def due_tomorrow?
    due_date - 1 == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def days_overdue
    if overdue?
      Date.today.to_time.to_i / SECONDS_PER_DAY - Transaction.last.due_date.to_time.to_i / SECONDS_PER_DAY
    end
  end
end
