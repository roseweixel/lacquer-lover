class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.integer :user_lacquer_id
      t.integer :requester_id
      t.integer :owner_id
      t.string :state, default: "pending"
      t.timestamps null: false
    end
  end
end
