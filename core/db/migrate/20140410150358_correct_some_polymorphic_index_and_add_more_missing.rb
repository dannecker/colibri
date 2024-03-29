class CorrectSomePolymorphicIndexAndAddMoreMissing < ActiveRecord::Migration
  def change
    add_index :colibri_addresses, :country_id
    add_index :colibri_addresses, :state_id
    remove_index :colibri_adjustments, [:source_type, :source_id]
    add_index :colibri_adjustments, [:source_id, :source_type]
    add_index :colibri_credit_cards, :address_id
    add_index :colibri_gateways, :active
    add_index :colibri_gateways, :test_mode
    add_index :colibri_inventory_units, :return_authorization_id
    add_index :colibri_line_items, :tax_category_id
    add_index :colibri_log_entries, [:source_id, :source_type]
    add_index :colibri_orders, :approver_id
    add_index :colibri_orders, :bill_address_id
    add_index :colibri_orders, :confirmation_delivered
    add_index :colibri_orders, :considered_risky
    add_index :colibri_orders, :created_by_id
    add_index :colibri_orders, :ship_address_id
    add_index :colibri_orders, :shipping_method_id
    add_index :colibri_orders_promotions, [:order_id, :promotion_id]
    add_index :colibri_payments, [:source_id, :source_type]
    add_index :colibri_prices, :deleted_at
    add_index :colibri_product_option_types, :position
    add_index :colibri_product_properties, :position
    add_index :colibri_product_properties, :property_id
    add_index :colibri_products, :shipping_category_id
    add_index :colibri_products, :tax_category_id
    add_index :colibri_promotion_action_line_items, :promotion_action_id
    add_index :colibri_promotion_action_line_items, :variant_id
    add_index :colibri_promotion_rules, :promotion_id
    add_index :colibri_promotions, :advertise
    add_index :colibri_return_authorizations, :number
    add_index :colibri_return_authorizations, :order_id
    add_index :colibri_return_authorizations, :stock_location_id
    add_index :colibri_shipments, :address_id
    add_index :colibri_shipping_methods, :deleted_at
    add_index :colibri_shipping_methods, :tax_category_id
    add_index :colibri_shipping_rates, :selected
    add_index :colibri_shipping_rates, :tax_rate_id
    add_index :colibri_state_changes, [:stateful_id, :stateful_type]
    add_index :colibri_state_changes, :user_id
    add_index :colibri_stock_items, :backorderable
    add_index :colibri_stock_locations, :active
    add_index :colibri_stock_locations, :backorderable_default
    add_index :colibri_stock_locations, :country_id
    add_index :colibri_stock_locations, :propagate_all_variants
    add_index :colibri_stock_locations, :state_id
    add_index :colibri_tax_categories, :deleted_at
    add_index :colibri_tax_categories, :is_default
    add_index :colibri_tax_rates, :deleted_at
    add_index :colibri_tax_rates, :included_in_price
    add_index :colibri_tax_rates, :show_rate_in_label
    add_index :colibri_tax_rates, :tax_category_id
    add_index :colibri_tax_rates, :zone_id
    add_index :colibri_taxonomies, :position
    add_index :colibri_taxons, :position
    add_index :colibri_trackers, :active
    add_index :colibri_variants, :deleted_at
    add_index :colibri_variants, :is_master
    add_index :colibri_variants, :position
    add_index :colibri_variants, :track_inventory
    add_index :colibri_zone_members, :zone_id
    add_index :colibri_zone_members, [:zoneable_id, :zoneable_type]
    add_index :colibri_zones, :default_tax
  end
end
