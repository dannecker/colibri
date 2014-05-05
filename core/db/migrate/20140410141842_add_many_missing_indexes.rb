class AddManyMissingIndexes < ActiveRecord::Migration
  def change
    add_index :colibri_adjustments, [:adjustable_id, :adjustable_type]
    add_index :colibri_adjustments, :eligible
    add_index :colibri_adjustments, :order_id
    add_index :colibri_promotions, :code
    add_index :colibri_promotions, :expires_at
    add_index :colibri_states, :country_id
    add_index :colibri_stock_items, :deleted_at
    add_index :colibri_option_types, :position
    add_index :colibri_option_values, :position
    add_index :colibri_product_option_types, :option_type_id
    add_index :colibri_product_option_types, :product_id
    add_index :colibri_products_taxons, :position
    add_index :colibri_promotions, :starts_at
    add_index :colibri_stores, :url
  end
end
