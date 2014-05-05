class RemoveValueTypeFromColibriPreferences < ActiveRecord::Migration
  def up
    remove_column :colibri_preferences, :value_type
  end
  def down
    raise ActiveRecord::IrreversableMigration
  end
end
