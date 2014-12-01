class CreateUserLacquerColors < ActiveRecord::Migration
  def change
    create_table :user_lacquer_colors do |t|
      t.integer :user_lacquer_id
      t.integer :color_id
    end
  end
end
