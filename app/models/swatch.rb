class Swatch < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :user
  
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  validates :image_file_size, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end
