class AddDefaultStateToTransactions < ActiveRecord::Migration
  def change
    change_column :transactions, :state, :string, default: "pending"
  end
end
