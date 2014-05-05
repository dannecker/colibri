class DropProductsCountOnHand < ActiveRecord::Migration
  def up
    remove_column :colibri_products, :count_on_hand
  end
end
