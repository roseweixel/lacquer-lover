FactoryGirl.define do
  sequence :brand_name do |n|
    "Brand#{n}"
  end

  factory :brand do
    name { generate(:brand_name) }
  end
end

