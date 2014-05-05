module Colibri
  class ProductOptionType < Colibri::Base
    belongs_to :product, class_name: 'Colibri::Product', inverse_of: :product_option_types
    belongs_to :option_type, class_name: 'Colibri::OptionType', inverse_of: :product_option_types
    acts_as_list scope: :product
  end
end
