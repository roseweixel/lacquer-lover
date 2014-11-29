class AddDueDateToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :due_date, :datetime
  end
end
