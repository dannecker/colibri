class AddPositionToClassifications < ActiveRecord::Migration
  def change
    add_column :colibri_products_taxons, :position, :integer
  end
end
