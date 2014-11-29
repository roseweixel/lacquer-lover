class Transaction < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'

  def owner
    User.find(user_lacquer.user_id)
  end

end
