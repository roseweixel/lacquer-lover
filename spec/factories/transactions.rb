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

FactoryGirl.define do
  factory :transaction do
    
  end

end
