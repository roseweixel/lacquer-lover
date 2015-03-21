# == Schema Information
#
# Table name: user_lacquers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  lacquer_id :integer
#  created_at :datetime
#  updated_at :datetime
#  loanable   :boolean          default(FALSE)
#  on_loan    :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :user_lacquer do
    
  end

end
