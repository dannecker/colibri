class AddToggleTaxRateDisplay < ActiveRecord::Migration
  def change
    add_column :colibri_tax_rates, :show_rate_in_label, :boolean, :default => true
  end
end
