class UserLacquer < ActiveRecord::Base
  belongs_to :user
  belongs_to :lacquer

  def available?
    loanable && !on_loan
  end

end
