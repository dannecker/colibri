class AddShipmentTotalToColibriOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :shipment_total, :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
  end
end
