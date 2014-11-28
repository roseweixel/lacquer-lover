class CreateFinishes < ActiveRecord::Migration
  def change
    create_table :finishes do |t|
      t.string :description
    end
  end
end
