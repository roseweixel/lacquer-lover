class AddAttachmentImageToSwatches < ActiveRecord::Migration
  def self.up
    change_table :swatches do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :swatches, :image
  end
end
