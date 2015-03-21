# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

FactoryGirl.define do
  factory :friendship do
    
  end

end
