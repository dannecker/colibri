FactoryGirl.define do
  factory :prototype, class: Colibri::Prototype do
    name 'Baseball Cap'
    properties { [create(:property)] }
  end
end
