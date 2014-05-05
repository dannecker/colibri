class AddPrimaryToColibriProductsTaxons < ActiveRecord::Migration
  def change
    add_column :colibri_products_taxons, :id, :primary_key
  end
end
