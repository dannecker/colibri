object @shipment
cache @shipment
attributes *shipment_attributes
node(:order_id) { |shipment| shipment.order.number }
node(:stock_location_name) { |shipment| shipment.stock_location.name }

child :shipping_rates => :shipping_rates do
  extends "colibri/api/shipping_rates/show"
end

child :selected_shipping_rate => :selected_shipping_rate do
  extends "colibri/api/shipping_rates/show"
end

child :shipping_methods => :shipping_methods do
  attributes :id, :name
  child :zones => :zones do
    attributes :id, :name, :description
  end

  child :shipping_categories => :shipping_categories do
    attributes :id, :name
  end
end

child :manifest => :manifest do
  child :variant => :variant do
    extends "colibri/api/variants/small"
  end
  node(:quantity) { |m| m.quantity }
  node(:states) { |m| m.states }
end
