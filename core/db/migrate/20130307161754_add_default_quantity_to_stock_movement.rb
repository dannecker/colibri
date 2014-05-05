class AddDefaultQuantityToStockMovement < ActiveRecord::Migration
  def change
    change_column :colibri_stock_movements, :quantity, :integer, :default => 0
  end
end
