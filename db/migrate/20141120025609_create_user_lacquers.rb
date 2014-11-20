class CreateUserLacquers < ActiveRecord::Migration
  def change
    create_table :user_lacquers do |t|
      t.integer :user_id
      t.integer :lacquer_id
      t.timestamps
    end
  end
end
