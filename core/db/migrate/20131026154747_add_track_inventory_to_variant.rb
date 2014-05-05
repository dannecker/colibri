class AddTrackInventoryToVariant < ActiveRecord::Migration
  def change
    add_column :colibri_variants, :track_inventory, :boolean, :default => true
  end
end
