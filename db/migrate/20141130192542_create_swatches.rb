class CreateSwatches < ActiveRecord::Migration
  def change
    create_table :swatches do |t|
      t.integer :lacquer_id
      t.integer :user_id
      t.string :attachment

      t.timestamps
    end
  end
end
