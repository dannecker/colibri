class Colibri::Base < ActiveRecord::Base
  include Colibri::Preferences::Preferable
  serialize :preferences, Hash
  after_initialize do
    self.preferences = default_preferences.merge(preferences) if has_attribute?(:preferences)
  end

  self.abstract_class = true
end
