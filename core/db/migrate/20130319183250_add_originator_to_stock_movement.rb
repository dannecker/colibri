class AddOriginatorToStockMovement < ActiveRecord::Migration
  def change
    change_table :colibri_stock_movements do |t|
      t.references :originator, polymorphic: true
    end
  end
end
