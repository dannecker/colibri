FactoryGirl.define do
  factory :calculator, class: Colibri::Calculator::FlatRate do
    after(:create) { |c| c.set_preference(:amount, 10.0) }
  end

  factory :no_amount_calculator, class: Colibri::Calculator::FlatRate do
    after(:create) { |c| c.set_preference(:amount, 0) }
  end

  factory :default_tax_calculator, class: Colibri::Calculator::DefaultTax do
  end
end
