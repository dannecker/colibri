class AddTaxRateLabel < ActiveRecord::Migration
  def change
    add_column :colibri_tax_rates, :name, :string
  end
end
