north_america = Colibri::Zone.find_by_name!("North America")
clothing = Colibri::TaxCategory.find_by_name!("Clothing")
tax_rate = Colibri::TaxRate.create(
  :name => "North America",
  :zone => north_america, 
  :amount => 0.05,
  :tax_category => clothing)
tax_rate.calculator = Colibri::Calculator::DefaultTax.create!
tax_rate.save!
