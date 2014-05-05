class AddUpdatedAtToColibriStates < ActiveRecord::Migration
  def up
    add_column :colibri_states, :updated_at, :datetime
  end

  def down
    remove_column :colibri_states, :updated_at
  end
end
