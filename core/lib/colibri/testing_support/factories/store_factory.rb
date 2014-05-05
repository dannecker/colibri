FactoryGirl.define do
  factory :store, class: Colibri::Store do
    sequence(:code) { |i| "colibri_#{i}" }
    name 'Colibri Test Store'
    url 'www.example.com'
    mail_from_address 'colibri@example.org'
  end
end
