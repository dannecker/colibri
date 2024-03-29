class ChangeOrdersTotalPrecision < ActiveRecord::Migration
   def change
    change_column :colibri_orders, :item_total,  :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
    change_column :colibri_orders, :total,  :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
    change_column :colibri_orders, :adjustment_total,  :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
    change_column :colibri_orders, :payment_total,  :decimal, :precision => 10, :scale => 2, :default => 0.0                                
   end
end
