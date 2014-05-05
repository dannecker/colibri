class CreateStockMovements < ActiveRecord::Migration
  def change
    create_table :colibri_stock_movements do |t|
      t.belongs_to :stock_item
      t.integer :quantity
      t.string :action

      t.timestamps
    end
    add_index :colibri_stock_movements, :stock_item_id
  end
end
