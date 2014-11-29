class AddLoanableAndOnLoanToUserLacquers < ActiveRecord::Migration
  def change
    add_column :user_lacquers, :loanable, :boolean, default: false
    add_column :user_lacquers, :on_loan, :boolean, default: false
  end
end
