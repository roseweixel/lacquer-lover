class AddAttachmentStoredImageToLacquers < ActiveRecord::Migration
  def self.up
    change_table :lacquers do |t|
      t.attachment :stored_image
    end
  end

  def self.down
    remove_attachment :lacquers, :stored_image
  end
end
