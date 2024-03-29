module Colibri
  class OptionType < Colibri::Base
    has_many :option_values, -> { order(:position) }, dependent: :destroy, inverse_of: :option_type
    has_many :product_option_types, dependent: :destroy, inverse_of: :option_type
    has_many :products, through: :product_option_types
    has_and_belongs_to_many :prototypes, join_table: 'colibri_option_types_prototypes'

    validates :name, :presentation, presence: true
    default_scope -> { order("#{self.table_name}.position") }

    accepts_nested_attributes_for :option_values, reject_if: lambda { |ov| ov[:name].blank? || ov[:presentation].blank? }, allow_destroy: true

    after_touch :touch_all_products

    def touch_all_products
      products.find_each(&:touch)
    end
  end
end
