class AddConfirmationDeliveredToColibriOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :confirmation_delivered, :boolean, default: false
  end
end
