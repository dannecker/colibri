class AddCurrencyToOrders < ActiveRecord::Migration
  def change
    add_column :colibri_orders, :currency, :string
  end
end
