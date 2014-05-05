class AddPromoTotalToLineItemsAndShipmentsAndOrders < ActiveRecord::Migration
  def change
    add_column :colibri_line_items, :promo_total, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :colibri_shipments, :promo_total, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :colibri_orders, :promo_total, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
