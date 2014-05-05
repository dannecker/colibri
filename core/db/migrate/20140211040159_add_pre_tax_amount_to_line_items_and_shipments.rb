class AddPreTaxAmountToLineItemsAndShipments < ActiveRecord::Migration
  def change
    add_column :colibri_line_items, :pre_tax_amount, :decimal, precision: 8, scale: 2
    add_column :colibri_shipments, :pre_tax_amount, :decimal, precision: 8, scale: 2
  end
end
