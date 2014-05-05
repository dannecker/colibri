class AddUniqueIndexToOrdersShipmentsAndStockTransfers < ActiveRecord::Migration
  def add
    add_index "colibri_orders", ["number"], :name => "number_idx_unique", :unique => true
    add_index "colibri_shipments", ["number"], :name => "number_idx_unique", :unique => true
    add_index "colibri_stock_transfers", ["number"], :name => "number_idx_unique", :unique => true
  end
end
