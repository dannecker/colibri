class AddPositionToTaxonomies < ActiveRecord::Migration
  def change
  	add_column :colibri_taxonomies, :position, :integer, :default => 0
  end
end
