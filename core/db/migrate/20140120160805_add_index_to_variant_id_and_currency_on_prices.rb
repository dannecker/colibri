class AddIndexToVariantIdAndCurrencyOnPrices < ActiveRecord::Migration
  def change
    add_index :colibri_prices, [:variant_id, :currency]
  end
end
