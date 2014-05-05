class AddStatesRequiredToCountries < ActiveRecord::Migration
  def change
    add_column :colibri_countries, :states_required, :boolean,:default => true
  end
end
