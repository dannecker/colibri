FactoryGirl.define do
  factory :shipping_category, class: Colibri::ShippingCategory do
    sequence(:name) { |n| "ShippingCategory ##{n}" }
  end
end
