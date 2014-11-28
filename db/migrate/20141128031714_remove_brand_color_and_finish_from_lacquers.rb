class RemoveBrandColorAndFinishFromLacquers < ActiveRecord::Migration
  def change
    remove_column :lacquers, :brand
    remove_column :lacquers, :color
    remove_column :lacquers, :finish
  end
end
