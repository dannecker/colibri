module Colibri
  class ShippingMethodCategory < Colibri::Base
    belongs_to :shipping_method, class_name: 'Colibri::ShippingMethod'
    belongs_to :shipping_category, class_name: 'Colibri::ShippingCategory'
  end
end
