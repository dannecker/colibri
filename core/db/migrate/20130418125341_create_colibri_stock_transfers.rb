class CreateColibriStockTransfers < ActiveRecord::Migration
  def change
    create_table :colibri_stock_transfers do |t|
      t.string :type
      t.string :reference_number
      t.integer :source_location_id
      t.integer :destination_location_id
      t.timestamps
    end

    add_index :colibri_stock_transfers, :source_location_id
    add_index :colibri_stock_transfers, :destination_location_id
  end
end
