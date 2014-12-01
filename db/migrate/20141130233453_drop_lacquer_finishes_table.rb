class DropLacquerFinishesTable < ActiveRecord::Migration
  def change
    drop_table :lacquer_finishes
  end
end
