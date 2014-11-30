class RemoveAttachmentFromSwatches < ActiveRecord::Migration
  def change
    remove_column :swatches, :attachment
  end
end
