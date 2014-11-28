class CreateLacquerFinishes < ActiveRecord::Migration
  def change
    create_table :lacquer_finishes do |t|
      t.integer :lacquer_id
      t.integer :finish_id
    end
  end
end
