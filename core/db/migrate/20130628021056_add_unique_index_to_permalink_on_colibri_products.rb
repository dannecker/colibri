class AddUniqueIndexToPermalinkOnColibriProducts < ActiveRecord::Migration
  def change
    add_index "colibri_products", ["permalink"], :name => "permalink_idx_unique", :unique => true
  end
end
