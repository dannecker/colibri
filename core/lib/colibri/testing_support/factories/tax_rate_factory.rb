FactoryGirl.define do
  factory :tax_rate, class: Colibri::TaxRate do
    zone
    amount 0.1
    tax_category
    association(:calculator, factory: :default_tax_calculator)
  end
end
