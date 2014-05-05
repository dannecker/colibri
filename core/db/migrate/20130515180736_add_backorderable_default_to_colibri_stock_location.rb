class AddBackorderableDefaultToColibriStockLocation < ActiveRecord::Migration
  def change
    add_column :colibri_stock_locations, :backorderable_default, :boolean, default: true
  end
end
