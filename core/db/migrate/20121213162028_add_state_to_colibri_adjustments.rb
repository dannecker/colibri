class AddStateToColibriAdjustments < ActiveRecord::Migration
  def change
    add_column :colibri_adjustments, :state, :string
    remove_column :colibri_adjustments, :locked
  end
end
