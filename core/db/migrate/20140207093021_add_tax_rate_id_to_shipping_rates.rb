class AddTaxRateIdToShippingRates < ActiveRecord::Migration
  def change
    add_column :colibri_shipping_rates, :tax_rate_id, :integer
  end
end
