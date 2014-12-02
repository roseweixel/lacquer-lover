class Brand < ActiveRecord::Base
  has_many :lacquers
  validates :name, presence: true
  validates :name, uniqueness: true

  def abbreviation
    name.split.first.downcase
  end
end

