FactoryGirl.define do
  factory :address, aliases: [:bill_address, :ship_address], class: Colibri::Address do
    firstname 'John'
    lastname 'Doe'
    company 'Company'
    address1 '10 Lovely Street'
    address2 'Northwest'
    city 'Herndon'
    zipcode '35005'
    phone '123-456-7890'
    alternative_phone '123-456-7899'

    state { |address| address.association(:state) }
    country do |address|
      if address.state
        address.state.country
      else
        address.association(:country)
      end
    end
  end
end
