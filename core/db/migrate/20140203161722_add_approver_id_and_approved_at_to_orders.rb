class AddApproverIdAndApprovedAtToOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :approver_id, :integer
    add_column :colibri_orders, :approved_at, :datetime
  end
end
