class RemoveShippingCategoryIdFromShippingMethod < ActiveRecord::Migration
  def change
    remove_column :colibri_shipping_methods, :shipping_category_id
  end
end
