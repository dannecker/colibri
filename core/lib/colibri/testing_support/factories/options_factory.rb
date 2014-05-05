FactoryGirl.define do
  factory :option_value, class: Colibri::OptionValue do
    name 'Size'
    presentation 'S'
    option_type
  end

  factory :option_type, class: Colibri::OptionType do
    name 'foo-size'
    presentation 'Size'
  end
end
