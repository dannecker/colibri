class RemoveDisplayOnFromPaymentMethods < ActiveRecord::Migration
  def up
    remove_column :colibri_payment_methods, :display_on
  end
end
