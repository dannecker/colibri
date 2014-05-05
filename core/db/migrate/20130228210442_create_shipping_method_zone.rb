class CreateShippingMethodZone < ActiveRecord::Migration
  def up
    create_table :shipping_methods_zones, :id => false do |t|
      t.integer :shipping_method_id
      t.integer :zone_id
    end
    # This association has been corrected in a latter migration
    # but when this database migration runs, the table is still incorrectly named
    # 'shipping_methods_zones' instead of 'spre_shipping_methods_zones'
    Colibri::ShippingMethod.has_and_belongs_to_many :zones, :join_table => 'shipping_methods_zones',
                                                          :class_name => 'Colibri::Zone',
                                                          :foreign_key => 'shipping_method_id'
    Colibri::ShippingMethod.all.each{|sm| sm.zones << Colibri::Zone.find(sm.zone_id)}

    remove_column :colibri_shipping_methods, :zone_id
  end

  def down
    drop_table :shipping_methods_zones
    add_column :colibri_shipping_methods, :zone_id, :integer
  end
end
