# == Schema Information
#
# Table name: user_lacquers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  lacquer_id :integer
#  created_at :datetime
#  updated_at :datetime
#  loanable   :boolean          default(FALSE)
#  on_loan    :boolean          default(FALSE)
#

class UserLacquer < ActiveRecord::Base
  belongs_to :user
  belongs_to :lacquer
  delegate :brand, :to => :lacquer
  delegate :name, :to => :lacquer

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

  before_destroy :confirm_no_transaction_for

  validates :lacquer_id, :user_id, presence: true

  def confirm_no_transaction_for
    self.transactions.where(state: ["pending", "accepted", "active"]).empty?
    !self.on_loan
  end

  def available?
    loanable && !on_loan
  end

  def swatch_image
    user = User.find(user_id)
    lacquer = Lacquer.find(self.lacquer_id)

    lacquer.swatches.each do |swatch|
      if swatch.image.file? && swatch.user_id == user.id
        return swatch.image.url(:thumb)
      end
    end
    return lacquer.swatches.first.image.url(:thumb) if lacquer.swatches.first.image.file?
  end

end
