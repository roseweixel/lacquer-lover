class AddBuyUrlToLacquers < ActiveRecord::Migration
  def change
    add_column :lacquers, :buy_url, :string
  end
end
