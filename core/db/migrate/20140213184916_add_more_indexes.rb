class AddMoreIndexes < ActiveRecord::Migration
  def change
    add_index :colibri_payment_methods, [:id, :type]
    add_index :colibri_calculators, [:id, :type]
    add_index :colibri_calculators, [:calculable_id, :calculable_type]
    add_index :colibri_payments, :payment_method_id
    add_index :colibri_promotion_actions, [:id, :type]
    add_index :colibri_promotion_actions, :promotion_id
    add_index :colibri_promotions, [:id, :type]
    add_index :colibri_option_values, :option_type_id
    add_index :colibri_shipments, :stock_location_id
  end
end
