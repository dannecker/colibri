class AddCvvResultCodeAndCvvResultMessageToColibriPayments < ActiveRecord::Migration
  def change
    add_column :colibri_payments, :cvv_response_code, :string
    add_column :colibri_payments, :cvv_response_message, :string
  end
end
