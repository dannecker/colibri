class AddCreatedByIdToColibriOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :created_by_id, :integer
  end
end
