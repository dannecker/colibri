FactoryGirl.define do
  factory :shipment, class: Colibri::Shipment do
    tracking 'U10000'
    number '100'
    cost 100.00
    state 'pending'
    order
    stock_location

    after(:create) do |shipment, evalulator|
      shipment.add_shipping_method(create(:shipping_method), true)

      shipment.order.line_items.each do |line_item|
        line_item.quantity.times do
          shipment.inventory_units.create(
            variant_id: line_item.variant_id,
            line_item_id: line_item.id
          )
        end
      end
    end
  end
end
