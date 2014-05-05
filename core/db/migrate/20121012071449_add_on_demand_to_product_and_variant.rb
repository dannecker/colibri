class AddOnDemandToProductAndVariant < ActiveRecord::Migration
  def change
  	add_column :colibri_products, :on_demand, :boolean, :default => false
  	add_column :colibri_variants, :on_demand, :boolean, :default => false
  end
end
