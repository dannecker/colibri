class AddOrderIdIndexToShipments < ActiveRecord::Migration
  def change
    add_index :colibri_shipments, :order_id
  end
end
