class AddDeletedAtToColibriPrices < ActiveRecord::Migration
  def change
    add_column :colibri_prices, :deleted_at, :datetime
  end
end
