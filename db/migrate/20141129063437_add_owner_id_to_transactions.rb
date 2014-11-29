class AddOwnerIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :owner_id, :integer
  end
end
