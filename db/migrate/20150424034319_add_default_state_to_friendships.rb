class AddDefaultStateToFriendships < ActiveRecord::Migration
  def change
    change_column :friendships, :state, :string, default: "pending"
  end
end
