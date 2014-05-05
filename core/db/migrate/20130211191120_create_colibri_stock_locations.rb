class CreateColibriStockLocations < ActiveRecord::Migration
  def change
    create_table :colibri_stock_locations do |t|
      t.string :name
      t.belongs_to :address

      t.timestamps
    end
    add_index :colibri_stock_locations, :address_id
  end
end
