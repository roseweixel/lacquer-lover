class AddDateBecameActiveToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :date_became_active, :datetime
  end
end
