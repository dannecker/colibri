class ChangeColibriPaymentsAmountPrecision < ActiveRecord::Migration
  def change
   
    change_column :colibri_payments, :amount,  :decimal, :precision => 10, :scale => 2, :default => 0.0, :null => false
                                   
  end
end
