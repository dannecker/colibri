class UpdateShipmentStateForCanceledOrders < ActiveRecord::Migration
  def up
    shipments = Colibri::Shipment.joins(:order).
      where("colibri_orders.state = 'canceled'")
    case Colibri::Shipment.connection.adapter_name
    when "SQLite3"
      shipments.update_all("state = 'cancelled'")
    when "MySQL" || "PostgreSQL"
      shipments.update_all("colibri_shipments.state = 'cancelled'")
    end
  end

  def down
  end
end
