# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  lacquer_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :user

  validates :user, :lacquer, presence: true
end
