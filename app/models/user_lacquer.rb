class UserLacquer < ActiveRecord::Base
  belongs_to :user
  belongs_to :lacquer

  has_many :transactions
  has_many :requesters, class_name: 'User', through: :transactions

  has_many :user_lacquer_colors
  has_many :colors, through: :user_lacquer_colors

  has_many :user_lacquer_finishes
  has_many :finishes, through: :user_lacquer_finishes

  accepts_nested_attributes_for :transactions
  accepts_nested_attributes_for :colors
  accepts_nested_attributes_for :finishes
  accepts_nested_attributes_for :user_lacquer_colors
  accepts_nested_attributes_for :user_lacquer_finishes

  #validate :no_current_transaction_for, :on => :destroy
  before_destroy :confirm_no_current_transaction

  def confirm_no_current_transaction
    self.transactions.where(state: ["pending", "accepted", "active"]).empty?
  end

  def available?
    loanable && !on_loan
  end

  def on_loan
    !self.transactions.where(state: ["accepted", "active"]).empty?
  end

  def swatch_image
    user = User.find(user_id)
    lacquer = Lacquer.find(self.lacquer_id)
    #binding.pry
    lacquer.swatches.each do |swatch|
      if swatch.image.file? && swatch.user_id == user.id
        return swatch.image.url(:thumb)
      end
    end
    return lacquer.swatches.first.image.url(:thumb) if lacquer.swatches.first.image.file?
  end

end
