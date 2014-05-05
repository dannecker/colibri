class CreateShippingMethodCategories < ActiveRecord::Migration
  def change
    create_table :colibri_shipping_method_categories do |t|
      t.integer :shipping_method_id, :null => false
      t.integer :shipping_category_id, :null => false

      t.timestamps
    end

    add_index :colibri_shipping_method_categories, :shipping_method_id
    add_index :colibri_shipping_method_categories, :shipping_category_id
  end
end
