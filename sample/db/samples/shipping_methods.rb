begin
north_america = Colibri::Zone.find_by_name!("North America")
rescue ActiveRecord::RecordNotFound
  puts "Couldn't find 'North America' zone. Did you run `rake db:seed` first?"
  puts "That task will set up the countries, states and zones required for Colibri."
  exit
end

europe_vat = Colibri::Zone.find_by_name!("EU_VAT")
shipping_category = Colibri::ShippingCategory.find_or_create_by!(name: 'Default')

Colibri::ShippingMethod.create!([
  {
    :name => "UPS Ground (USD)",
    :zones => [north_america],
    :calculator => Colibri::Calculator::Shipping::FlatRate.create!,
    :shipping_categories => [shipping_category]
  },
  {
    :name => "UPS Two Day (USD)",
    :zones => [north_america],
    :calculator => Colibri::Calculator::Shipping::FlatRate.create!,
    :shipping_categories => [shipping_category]
  },
  {
    :name => "UPS One Day (USD)",
    :zones => [north_america],
    :calculator => Colibri::Calculator::Shipping::FlatRate.create!,
    :shipping_categories => [shipping_category]
  },
  {
    :name => "UPS Ground (EU)",
    :zones => [europe_vat],
    :calculator => Colibri::Calculator::Shipping::FlatRate.create!,
    :shipping_categories => [shipping_category]
  },
  {
    :name => "UPS Ground (EUR)",
    :zones => [europe_vat],
    :calculator => Colibri::Calculator::Shipping::FlatRate.create!,
    :shipping_categories => [shipping_category]
  }
])

{
  "UPS Ground (USD)" => [5, "USD"],
  "UPS Ground (EU)" => [5, "USD"],
  "UPS One Day (USD)" => [15, "USD"],
  "UPS Two Day (USD)" => [10, "USD"],
  "UPS Ground (EUR)" => [8, "EUR"]
}.each do |shipping_method_name, (price, currency)|
  shipping_method = Colibri::ShippingMethod.find_by_name!(shipping_method_name)
  shipping_method.calculator.preferences = {
    amount: price,
    currency: currency
  }
  shipping_method.calculator.save!
  shipping_method.save!
end

