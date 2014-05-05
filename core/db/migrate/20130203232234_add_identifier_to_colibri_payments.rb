class AddIdentifierToColibriPayments < ActiveRecord::Migration
  def change
    add_column :colibri_payments, :identifier, :string
  end
end
