class RenameAdjustmentFields < ActiveRecord::Migration
  def up
    remove_column :colibri_adjustments, :originator_id
    remove_column :colibri_adjustments, :originator_type

    add_column :colibri_adjustments, :order_id, :integer unless column_exists?(:colibri_adjustments, :order_id)

    # This enables the Colibri::Order#all_adjustments association to work correctly
    Colibri::Adjustment.reset_column_information
    Colibri::Adjustment.find_each do |adjustment|
      if adjustment.adjustable.is_a?(Colibri::Order)
        adjustment.order = adjustment.adjustable
        adjustment.save
      end
    end
  end
end
