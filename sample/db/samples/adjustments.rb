Colibri::Sample.load_sample("orders")

first_order = Colibri::Order.find_by_number!("R123456789")
last_order = Colibri::Order.find_by_number!("R987654321")

first_order.adjustments.create!(
  :amount => 0,
  :source => Colibri::TaxRate.find_by_name!("North America"),
  :label => "Tax",
  :state => "open",
  :mandatory => true)

last_order.adjustments.create!(
  :amount => 0,
  :source => Colibri::TaxRate.find_by_name!("North America"),
  :label => "Tax",
  :state => "open",
  :mandatory => true)
