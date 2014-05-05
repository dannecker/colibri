class CreateColibriOrdersPromotions < ActiveRecord::Migration
  def change
    create_table :colibri_orders_promotions, :id => false do |t|
      t.references :order
      t.references :promotion
    end
  end
end
