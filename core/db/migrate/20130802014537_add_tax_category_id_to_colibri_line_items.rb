class AddTaxCategoryIdToColibriLineItems < ActiveRecord::Migration
  def change
    add_column :colibri_line_items, :tax_category_id, :integer
  end
end
