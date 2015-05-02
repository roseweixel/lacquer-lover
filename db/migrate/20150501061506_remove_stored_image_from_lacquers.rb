class RemoveStoredImageFromLacquers < ActiveRecord::Migration
  def change
    remove_column :lacquers, :stored_image
  end
end
