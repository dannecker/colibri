class RenameApiKeyToColibriApiKey < ActiveRecord::Migration
  def change
    unless defined?(User)
      rename_column :colibri_users, :api_key, :colibri_api_key
    end
  end
end
