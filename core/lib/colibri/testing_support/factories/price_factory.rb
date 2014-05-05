FactoryGirl.define do
  factory :price, class: Colibri::Price do
    variant
    amount 19.99
    currency 'USD'
  end
end
