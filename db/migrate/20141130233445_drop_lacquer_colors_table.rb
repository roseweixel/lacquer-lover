class DropLacquerColorsTable < ActiveRecord::Migration
  def change
    drop_table :lacquer_colors
  end
end
