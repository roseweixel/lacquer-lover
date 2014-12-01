class CreateUserLacquerFinishes < ActiveRecord::Migration
  def change
    create_table :user_lacquer_finishes do |t|
      t.integer :user_lacquer_id
      t.integer :finish_id
    end
  end
end
