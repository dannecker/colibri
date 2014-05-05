class AddSkuIndexToColibriVariants < ActiveRecord::Migration
  def change
    add_index :colibri_variants, :sku
  end
end
