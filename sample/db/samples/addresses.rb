united_states = Colibri::Country.find_by_name!("United States")
new_york = Colibri::State.find_by_name!("New York")

# Billing address
Colibri::Address.create!(
  :firstname => Faker::Name.first_name,
  :lastname => Faker::Name.last_name,
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => Faker::Address.city,
  :state => new_york,
  :zipcode => 16804,
  :country => united_states,
  :phone => Faker::PhoneNumber.phone_number)

#Shipping address
Colibri::Address.create!(
  :firstname => Faker::Name.first_name,
  :lastname => Faker::Name.last_name,
  :address1 => Faker::Address.street_address,
  :address2 => Faker::Address.secondary_address,
  :city => Faker::Address.city,
  :state => new_york,
  :zipcode => 16804,
  :country => united_states,
  :phone => Faker::PhoneNumber.phone_number)
