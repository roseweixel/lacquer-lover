class AddDefaultPictureAndItemUrlToLacquers < ActiveRecord::Migration
  def change
    add_column :lacquers, :default_picture, :string
    add_column :lacquers, :item_url, :string
  end
end
