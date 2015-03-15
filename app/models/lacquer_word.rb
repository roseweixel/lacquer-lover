class LacquerWord < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :word

  validates :lacquer_id, presence: true
  validates :word_id, presence: true
  validates_uniqueness_of :lacquer_id, scope: :word_id
end
