class AddStockLocationIdToColibriShipments < ActiveRecord::Migration
  def change
    add_column :colibri_shipments, :stock_location_id, :integer
  end
end
