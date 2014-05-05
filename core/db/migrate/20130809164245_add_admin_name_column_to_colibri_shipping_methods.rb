class AddAdminNameColumnToColibriShippingMethods < ActiveRecord::Migration
  def change
    add_column :colibri_shipping_methods, :admin_name, :string
  end
end
