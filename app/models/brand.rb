# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Brand < ActiveRecord::Base
  has_many :lacquers
  has_many :user_lacquers, through: :lacquers
  has_many :favorites, through: :lacquers
  has_many :users, -> { uniq }, through: :user_lacquers
  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :user_lacquers

  def abbreviation
    "#{name.split.first.gsub(/\W/, "").downcase}#{id}"
  end

  SEEDED_BRAND_NAMES = ['OPI', 'China Glaze', 'Butter London', 'Deborah Lippmann', 'Nails Inc.', 'Zoya', 'Essie', 'I Love Nail Polish (ILNP)']

  BRANDS_WITH_ITEM_URL_AS_BUY_IT_URL = SEEDED_BRAND_NAMES - ['OPI', 'China Glaze']
end

