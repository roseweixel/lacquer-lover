class Gift < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  delegate :lacquer, to: :user_lacquer

  validates_presence_of :user_lacquer_id

  after_save :update_user_lacquer_transaction_to_completed

  def transfer_user_lacquer_from_owner_to_requester
    user_lacquer.update(user_id: requester.id)
  end

  def update_user_lacquer_transaction_to_completed
    transaction = Transaction.find_by(user_lacquer_id: user_lacquer_id)
    if state == 'completed' && transaction
      transaction.update(state: 'completed')
      transaction.user_lacquer.update(on_loan: 'false')
    end
  end
end
