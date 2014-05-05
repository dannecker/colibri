class RemoveNotNullConstraintFromProductsOnHand < ActiveRecord::Migration
  def up
    change_column :colibri_products, :count_on_hand, :integer, :null => true
    change_column :colibri_variants, :count_on_hand, :integer, :null => true
  end

  def down
    change_column :colibri_products, :count_on_hand, :integer, :null => false
    change_column :colibri_variants, :count_on_hand, :integer, :null => false
  end
end
