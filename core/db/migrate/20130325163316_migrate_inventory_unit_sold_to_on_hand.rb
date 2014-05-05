class MigrateInventoryUnitSoldToOnHand < ActiveRecord::Migration
  def up
    Colibri::InventoryUnit.where(:state => 'sold').update_all(:state => 'on_hand')
  end

  def down
    Colibri::InventoryUnit.where(:state => 'on_hand').update_all(:state => 'sold')
  end
end
