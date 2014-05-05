class AddPreferenceStoreToEverything < ActiveRecord::Migration
  def change
    add_column :colibri_calculators, :preferences, :text
    add_column :colibri_gateways, :preferences, :text
    add_column :colibri_payment_methods, :preferences, :text
    add_column :colibri_promotion_rules, :preferences, :text
  end
end
