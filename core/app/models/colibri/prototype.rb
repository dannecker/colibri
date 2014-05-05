module Colibri
  class Prototype < Colibri::Base
    has_and_belongs_to_many :properties, join_table: :colibri_properties_prototypes
    has_and_belongs_to_many :option_types, join_table: :colibri_option_types_prototypes

    validates :name, presence: true
  end
end
