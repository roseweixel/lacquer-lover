class CreateLacquers < ActiveRecord::Migration
  def change
    create_table :lacquers do |t|
      t.string :brand
      t.string :name
      t.string :color
      t.string :finish
      t.timestamps
    end
  end
end
