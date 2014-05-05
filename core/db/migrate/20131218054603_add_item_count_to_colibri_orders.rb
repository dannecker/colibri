class AddItemCountToColibriOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :item_count, :integer, :default => 0
  end
end
