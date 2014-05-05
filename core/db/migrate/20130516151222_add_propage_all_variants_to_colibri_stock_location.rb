class AddPropageAllVariantsToColibriStockLocation < ActiveRecord::Migration
  def change
    add_column :colibri_stock_locations, :propagate_all_variants, :boolean, default: true
  end
end
