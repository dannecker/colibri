FactoryGirl.define do
  factory :line_item, class: Colibri::LineItem do
    quantity 1
    price { BigDecimal.new('10.00') }
    order
    variant
  end
end
