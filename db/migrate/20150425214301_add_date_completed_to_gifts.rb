class AddDateCompletedToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :date_completed, :datetime
  end
end
