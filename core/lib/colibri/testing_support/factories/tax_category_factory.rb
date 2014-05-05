FactoryGirl.define do
  factory :tax_category, class: Colibri::TaxCategory do
    name { "TaxCategory - #{rand(999999)}" }
    description { generate(:random_string) }
  end
end
