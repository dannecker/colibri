class AddDisplayOnToColibriPaymentMethods < ActiveRecord::Migration
  def self.up
    add_column :colibri_payment_methods, :display_on, :string
  end

  def self.down
    remove_column :colibri_payment_methods, :display_on
  end
end
