# == Schema Information
#
# Table name: lacquers
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  brand_id         :integer
#  user_added_by_id :integer
#  default_picture  :string(255)
#  item_url         :string(255)
#

FactoryGirl.define do
  factory :lacquer do
    
  end

end
