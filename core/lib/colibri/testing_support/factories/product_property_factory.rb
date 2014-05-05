FactoryGirl.define do
  factory :product_property, class: Colibri::ProductProperty do
    product
    property
  end
end
