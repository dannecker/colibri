class AddAdditionalStoreFields < ActiveRecord::Migration
  def change
    add_column :colibri_stores, :code, :string unless column_exists?(:colibri_stores, :code)
    add_column :colibri_stores, :default, :boolean, default: false, null: false unless column_exists?(:colibri_stores, :default)
    add_index :colibri_stores, :code
    add_index :colibri_stores, :default
  end
end
