class AddTrackingUrlToColibriShippingMethods < ActiveRecord::Migration
  def change
    add_column :colibri_shipping_methods, :tracking_url, :string
  end
end
