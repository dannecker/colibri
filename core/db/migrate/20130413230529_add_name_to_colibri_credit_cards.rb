class AddNameToColibriCreditCards < ActiveRecord::Migration
  def change
    add_column :colibri_credit_cards, :name, :string
  end
end
