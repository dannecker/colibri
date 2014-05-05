class RenameShippingMethodsZonesToColibriShippingMethodsZones < ActiveRecord::Migration
  def change
    rename_table :shipping_methods_zones, :colibri_shipping_methods_zones
  end
end
