class Swatch < ActiveRecord::Base
  belongs_to :lacquer
  belongs_to :user
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  #before_validation { image.clear if @delete_image }
  validates :image_file_size, presence: true
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  # def delete_image
  #   @delete_image ||= false
  # end

  # def delete_image=(value)
  #   @delete_image  = !value.to_i.zero?
  # end

end
