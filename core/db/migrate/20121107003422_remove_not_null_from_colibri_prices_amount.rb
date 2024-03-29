class RemoveNotNullFromColibriPricesAmount < ActiveRecord::Migration
  def up
    change_column :colibri_prices, :amount, :decimal, :precision => 8, :scale => 2, :null => true
  end

  def down
    change_column :colibri_prices, :amount, :decimal, :precision => 8, :scale => 2, :null => false
  end
end
