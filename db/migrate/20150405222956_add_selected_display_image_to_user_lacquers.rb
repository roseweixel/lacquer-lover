class AddSelectedDisplayImageToUserLacquers < ActiveRecord::Migration
  def change
    add_column :user_lacquers, :selected_display_image, :string
  end
end
