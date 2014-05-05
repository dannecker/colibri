class AddTimestampsToColibriAssets < ActiveRecord::Migration
  def change
    add_column :colibri_assets, :created_at, :datetime
    add_column :colibri_assets, :updated_at, :datetime
  end
end
