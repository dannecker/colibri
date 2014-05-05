class AddStockLocationToRma < ActiveRecord::Migration
  def change
    add_column :colibri_return_authorizations, :stock_location_id, :integer
  end
end
