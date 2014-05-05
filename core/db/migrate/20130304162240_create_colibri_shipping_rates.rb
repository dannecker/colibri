class CreateColibriShippingRates < ActiveRecord::Migration
  def up
    create_table :colibri_shipping_rates do |t|
      t.belongs_to :shipment
      t.belongs_to :shipping_method
      t.boolean :selected, :default => false
      t.decimal :cost, :precision => 8, :scale => 2
      t.timestamps
    end
    add_index(:colibri_shipping_rates, [:shipment_id, :shipping_method_id],
              :name => 'colibri_shipping_rates_join_index',
              :unique => true)

    # Colibri::Shipment.all.each do |shipment|
    #   shipping_method = Colibri::ShippingMethod.find(shipment.shipment_method_id)
    #   shipment.add_shipping_method(shipping_method, true)
    # end
  end

  def down
    # add_column :colibri_shipments, :shipping_method_id, :integer
    drop_table :colibri_shipping_rates
  end
end
