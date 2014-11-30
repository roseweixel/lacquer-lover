class AddUserAddedByIdToLacquers < ActiveRecord::Migration
  def change
    add_column :lacquers, :user_added_by_id, :integer 
  end
end
