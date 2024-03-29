class CreateColibriStockItems < ActiveRecord::Migration
  def change
    create_table :colibri_stock_items do |t|
      t.belongs_to :stock_location
      t.belongs_to :variant
      t.integer :count_on_hand, null: false, default: 0
      t.integer :lock_version

      t.timestamps
    end
    add_index :colibri_stock_items, :stock_location_id
    add_index :colibri_stock_items, [:stock_location_id, :variant_id], :name => 'stock_item_by_loc_and_var_id'
  end
end
