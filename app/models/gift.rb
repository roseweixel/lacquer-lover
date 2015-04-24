class Gift < ActiveRecord::Base
  belongs_to :user_lacquer
  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
end
