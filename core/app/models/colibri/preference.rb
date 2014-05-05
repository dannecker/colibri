class Colibri::Preference < Colibri::Base
  serialize :value

  validates :key, presence: true
end
