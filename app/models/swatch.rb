# == Schema Information
#
# Table name: swatches
#
#  id                 :integer          not null, primary key
#  lacquer_id         :integer
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Swatch < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :user
  
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  validates :image_file_size, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end
