class AddPositionToProductProperties < ActiveRecord::Migration
  def change
    add_column :colibri_product_properties, :position, :integer, :default => 0
  end
end

