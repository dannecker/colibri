class AddUserIdIndexToColibriOrders < ActiveRecord::Migration
  def change
    add_index :colibri_orders, :user_id
  end
end
