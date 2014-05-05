class UpgradeAdjustments < ActiveRecord::Migration
  def up
    # Temporarily make originator association available
    Colibri::Adjustment.class_eval do
      belongs_to :originator, polymorphic: true
    end
    # Shipping adjustments are now tracked as fields on the object
    add_column :colibri_shipments, :adjustment_total, :decimal, :precision => 10, :scale => 2, :default => 0.0
    Colibri::Adjustment.where(:source_type => "Colibri::Shipment").find_each do |adjustment|
      # Account for possible invalid data
      next if adjustment.source.nil?
      adjustment.source.update_column(:adjustment_total, adjustment.amount)
      adjustment.destroy
    end

    # Tax adjustments have their sources altered
    Colibri::Adjustment.where(:originator_type => "Colibri::TaxRate").find_each do |adjustment|
      adjustment.source = adjustment.originator
      adjustment.save
    end

    # Promotion adjustments have their source altered also
    Colibri::Adjustment.where(:originator_type => "Colibri::PromotionAction").find_each do |adjustment|
      next if adjustment.originator.nil?
      adjustment.source = adjustment.originator
      begin
        if adjustment.source.calculator_type == "Colibri::Calculator::FreeShipping"
          # Previously this was a Colibri::Promotion::Actions::CreateAdjustment
          # And it had a calculator to work out FreeShipping
          # In Colibri 2.2, the "calculator" is now the action itself.
          adjustment.source.becomes(Colibri::Promotion::Actions::FreeShipping)
        end
      rescue
        # Fail silently. This is primarily in instances where the calculator no longer exists
      end

      adjustment.save
    end
  end
end
