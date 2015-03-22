# == Schema Information
#
# Table name: lacquer_words
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  lacquer_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class LacquerWord < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :word

  validates :lacquer_id, presence: true
  validates :word_id, presence: true
  validates_uniqueness_of :lacquer_id, scope: :word_id
end
