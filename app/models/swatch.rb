class Swatch < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  
  belongs_to :lacquer
  belongs_to :user
  validates :attachment, presence: true
end
