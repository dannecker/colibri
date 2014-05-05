class UpdateAdjustmentStates < ActiveRecord::Migration
  def up
    Colibri::Order.complete.find_each do |order|
      order.adjustments.update_all(:state => 'closed')
    end

    Colibri::Shipment.shipped.includes(:adjustment).find_each do |shipment|
      shipment.adjustment.update_column(:state, 'finalized') if shipment.adjustment
    end

    Colibri::Adjustment.where(:state => nil).update_all(:state => 'open')
  end

  def down
  end
end
