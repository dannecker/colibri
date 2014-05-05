class IndexCompletedAtOnColibriOrders < ActiveRecord::Migration
  def change
    add_index :colibri_orders, :completed_at
  end
end
