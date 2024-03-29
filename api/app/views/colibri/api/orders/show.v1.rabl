object @order
extends "colibri/api/orders/order"

if lookup_context.find_all("colibri/api/orders/#{root_object.state}").present?
  extends "colibri/api/orders/#{root_object.state}"
end

child :billing_address => :bill_address do
  extends "colibri/api/addresses/show"
end

child :shipping_address => :ship_address do
  extends "colibri/api/addresses/show"
end

child :line_items => :line_items do
  extends "colibri/api/line_items/show"
end

child :payments => :payments do
  attributes *payment_attributes

  child :payment_method => :payment_method do
    attributes :id, :name, :environment
  end

  child :source => :source do
    attributes *payment_source_attributes
  end
end

child :shipments => :shipments do
  extends "colibri/api/shipments/small"
end

child :adjustments => :adjustments do
  extends "colibri/api/adjustments/show"
end

# Necessary for backend's order interface
node :permissions do
  { can_update: current_ability.can?(:update, root_object) }
end
