class SetDefaultShippingRateCost < ActiveRecord::Migration
  def change
    change_column :colibri_shipping_rates, :cost, :decimal, default: 0, precision: 8, scale: 2
  end
end
