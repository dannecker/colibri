class SetBackorderableToDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :colibri_stock_items, :backorderable, :boolean, :default => false
    change_column :colibri_stock_locations, :backorderable_default, :boolean, :default => false
  end
end
