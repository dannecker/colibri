class SetDefaultStockLocationOnShipments < ActiveRecord::Migration
  def change
    if Colibri::Shipment.where('stock_location_id IS NULL').count > 0
      location = Colibri::StockLocation.find_by(name: 'default') || Colibri::StockLocation.first
      Colibri::Shipment.where('stock_location_id IS NULL').update_all(stock_location_id: location.id)
    end
  end
end
