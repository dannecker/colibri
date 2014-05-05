class AddPendingToInventoryUnit < ActiveRecord::Migration
  def change
    add_column :colibri_inventory_units, :pending, :boolean, :default => true
    Colibri::InventoryUnit.update_all(:pending => false)
  end
end
