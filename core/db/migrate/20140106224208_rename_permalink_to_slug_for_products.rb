class RenamePermalinkToSlugForProducts < ActiveRecord::Migration
  def change
    rename_column :colibri_products, :permalink, :slug
  end
end
