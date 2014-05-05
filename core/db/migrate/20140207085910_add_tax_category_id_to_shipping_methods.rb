class AddTaxCategoryIdToShippingMethods < ActiveRecord::Migration
  def change
    add_column :colibri_shipping_methods, :tax_category_id, :integer
  end
end
