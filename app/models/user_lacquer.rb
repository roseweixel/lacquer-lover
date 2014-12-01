class UserLacquer < ActiveRecord::Base
  belongs_to :user
  belongs_to :lacquer

  has_many :transactions
  has_many :requesters, class_name: 'User', through: :transactions

  has_many :user_lacquer_colors
  has_many :colors, through: :user_lacquer_colors

  has_many :user_lacquer_finishes
  has_many :finishes, through: :finishes

  accepts_nested_attributes_for :transactions

  def available?
    loanable && !on_loan
  end

end
