class AddCostCurrencyToVariants < ActiveRecord::Migration
  def change
    add_column :colibri_variants, :cost_currency, :string, :after => :cost_price
  end
end
