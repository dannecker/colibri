module Colibri
  class ZoneMember < Colibri::Base
    belongs_to :zone, class_name: 'Colibri::Zone', counter_cache: true
    belongs_to :zoneable, polymorphic: true

    def name
      return nil if zoneable.nil?
      zoneable.name
    end
  end
end
