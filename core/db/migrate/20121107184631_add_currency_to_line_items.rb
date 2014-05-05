class AddCurrencyToLineItems < ActiveRecord::Migration
  def change
    add_column :colibri_line_items, :currency, :string
  end
end
