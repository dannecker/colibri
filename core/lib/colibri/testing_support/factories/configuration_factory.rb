FactoryGirl.define do
  factory :configuration, class: Colibri::Configuration do
    name 'Default Configuration'
    type 'app_configuration'
  end
end
