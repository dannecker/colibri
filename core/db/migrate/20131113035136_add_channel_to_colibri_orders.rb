class AddChannelToColibriOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :channel, :string, default: "colibri"
  end
end
