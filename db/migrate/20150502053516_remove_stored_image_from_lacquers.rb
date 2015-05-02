class RemoveStoredImageFromLacquers < ActiveRecord::Migration
  def change
    remove_attachment :lacquers, :stored_image
  end
end
