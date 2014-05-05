class AddUpdatedAtToColibriCountries < ActiveRecord::Migration
  def up
    add_column :colibri_countries, :updated_at, :datetime
  end

  def down
    remove_column :colibri_countries, :updated_at
  end
end
