class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_lacquer_id
      t.integer :requester_id
      t.string :type
      t.datetime :date_ended
      t.timestamps
    end
  end
end
