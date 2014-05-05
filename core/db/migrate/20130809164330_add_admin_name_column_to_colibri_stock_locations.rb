class AddAdminNameColumnToColibriStockLocations < ActiveRecord::Migration
  def change
    add_column :colibri_stock_locations, :admin_name, :string
  end
end
