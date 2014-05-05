class AddTaxCategoryToVariants < ActiveRecord::Migration
  def change
    add_column :colibri_variants, :tax_category_id, :integer
    add_index  :colibri_variants, :tax_category_id
  end
end
