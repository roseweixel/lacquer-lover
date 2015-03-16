# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  sequence :brand_name do |n|
    "Brand#{n}"
  end

  factory :brand do
    name { generate(:brand_name) }
  end
end

