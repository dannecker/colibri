FactoryGirl.define do
  factory :product_option_type, class: Colibri::ProductOptionType do
    product
    option_type
  end
end
