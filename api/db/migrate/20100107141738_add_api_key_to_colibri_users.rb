class AddApiKeyToColibriUsers < ActiveRecord::Migration
  def change
    unless defined?(User)
      add_column :colibri_users, :api_key, :string, :limit => 40
    end
  end
end
