class AddGiftableToUserLacquers < ActiveRecord::Migration
  def change
    add_column :user_lacquers, :giftable, :boolean, default: false
  end
end
