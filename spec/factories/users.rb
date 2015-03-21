# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  provider         :string(255)
#  uid              :string(255)
#  name             :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  email            :string(255)
#  image            :string(255)
#

FactoryGirl.define do
  factory :user do

  end
end
