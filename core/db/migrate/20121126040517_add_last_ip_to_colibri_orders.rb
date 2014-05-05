class AddLastIpToColibriOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :last_ip_address, :string
  end
end
