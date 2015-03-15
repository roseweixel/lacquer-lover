class CreateLacquerWords < ActiveRecord::Migration
  def change
    create_table :lacquer_words do |t|
      t.integer :word_id
      t.integer :lacquer_id
      t.timestamps
    end
  end
end
