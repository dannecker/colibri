class RemoveOnDemandFromProductAndVariant < ActiveRecord::Migration
  def change
    remove_column :colibri_products, :on_demand
    remove_column :colibri_variants, :on_demand
  end
end
