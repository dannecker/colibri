Colibri::Gateway::Bogus.create!(
  {
    :name => "Credit Card",
    :description => "Bogus payment gateway for development.",
    :environment => "development",
    :active => true
  }
)

Colibri::Gateway::Bogus.create!(
  {
    :name => "Credit Card",
    :description => "Bogus payment gateway for production.",
    :environment => "production",
    :active => true
  }
)

Colibri::Gateway::Bogus.create!(
  {
    :name => "Credit Card",
    :description => "Bogus payment gateway for staging.",
    :environment => "staging",
    :active => true
  }
)

Colibri::Gateway::Bogus.create!(
  {
    :name => "Credit Card",
    :description => "Bogus payment gateway for test.",
    :environment => "test",
    :active => true
  }
)

Colibri::PaymentMethod::Check.create!(
  {
    :name => "Check",
    :description => "Pay by check.",
    :active => true
  }
)
