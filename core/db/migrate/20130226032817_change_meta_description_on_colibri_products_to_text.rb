class ChangeMetaDescriptionOnColibriProductsToText < ActiveRecord::Migration
  def change
    change_column :colibri_products, :meta_description, :text, :limit => nil
  end
end
