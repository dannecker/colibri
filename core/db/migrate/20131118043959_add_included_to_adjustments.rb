class AddIncludedToAdjustments < ActiveRecord::Migration
  def change
    add_column :colibri_adjustments, :included, :boolean, :default => false unless Colibri::Adjustment.column_names.include?("included")
  end
end
