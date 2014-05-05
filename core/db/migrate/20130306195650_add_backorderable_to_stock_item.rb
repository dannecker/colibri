class AddBackorderableToStockItem < ActiveRecord::Migration
  def change
    add_column :colibri_stock_items, :backorderable, :boolean, :default => true
  end
end
