class AddUserIdToColibriCreditCards < ActiveRecord::Migration
  def change
    unless Colibri::CreditCard.column_names.include? "user_id"
      add_column :colibri_credit_cards, :user_id, :integer
      add_index :colibri_credit_cards, :user_id
    end

    unless Colibri::CreditCard.column_names.include? "payment_method_id"
      add_column :colibri_credit_cards, :payment_method_id, :integer
      add_index :colibri_credit_cards, :payment_method_id
    end
  end
end
