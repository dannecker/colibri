class AddIndexToUserColibriApiKey < ActiveRecord::Migration
  def change
    unless defined?(User)
      add_index :colibri_users, :colibri_api_key
    end
  end
end
