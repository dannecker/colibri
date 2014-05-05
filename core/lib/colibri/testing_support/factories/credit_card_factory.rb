FactoryGirl.define do
  factory :credit_card, class: Colibri::CreditCard do
    verification_value 123
    month 12
    year { Time.now.year }
    number '4111111111111111'
    name 'Colibri Commerce'
  end
end
