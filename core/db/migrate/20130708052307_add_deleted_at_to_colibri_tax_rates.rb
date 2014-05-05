class AddDeletedAtToColibriTaxRates < ActiveRecord::Migration
  def change
    add_column :colibri_tax_rates, :deleted_at, :datetime
  end
end
