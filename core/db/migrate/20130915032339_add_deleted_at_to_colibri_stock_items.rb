class AddDeletedAtToColibriStockItems < ActiveRecord::Migration
  def change
    add_column :colibri_stock_items, :deleted_at, :datetime
  end
end
