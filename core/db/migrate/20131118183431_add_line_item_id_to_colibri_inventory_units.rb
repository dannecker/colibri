class AddLineItemIdToColibriInventoryUnits < ActiveRecord::Migration
  def change
    # Stores running the product-assembly extension already have a line_item_id column
    unless column_exists? Colibri::InventoryUnit.table_name, :line_item_id
      add_column :colibri_inventory_units, :line_item_id, :integer
      add_index :colibri_inventory_units, :line_item_id

      shipments = Colibri::Shipment.includes(:inventory_units, :order)

      shipments.find_each do |shipment|
        shipment.inventory_units.group_by(&:variant).each do |variant, units|

          line_item = shipment.order.find_line_item_by_variant(variant)
          next unless line_item

          Colibri::InventoryUnit.where(id: units.map(&:id)).update_all(line_item_id: line_item.id)
        end
      end
    end
  end
end
