class CreateLacquerColors < ActiveRecord::Migration
  def change
    create_table :lacquer_colors do |t|
      t.integer :lacquer_id
      t.integer :color_id
    end
  end
end
