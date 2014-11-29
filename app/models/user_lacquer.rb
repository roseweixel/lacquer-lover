class UserLacquer < ActiveRecord::Base
  belongs_to :user
  belongs_to :lacquer

  has_many :transactions
  has_many :requesters, class_name: 'User', through: :transactions

  accepts_nested_attributes_for :transactions

  def available?
    loanable && !on_loan
  end

end
