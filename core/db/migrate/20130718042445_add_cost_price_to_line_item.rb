class AddCostPriceToLineItem < ActiveRecord::Migration
  def change
    add_column :colibri_line_items, :cost_price, :decimal, :precision => 8, :scale => 2
  end
end
