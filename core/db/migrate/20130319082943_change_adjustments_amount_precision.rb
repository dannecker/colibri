class ChangeAdjustmentsAmountPrecision < ActiveRecord::Migration
  def change
   
    change_column :colibri_adjustments, :amount,  :decimal, :precision => 10, :scale => 2
                                   
  end
end
