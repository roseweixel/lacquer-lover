class AddBrandIdToLacquers < ActiveRecord::Migration
  def change
    add_column :lacquers, :brand_id, :integer
  end
end
