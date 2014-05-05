require_dependency 'colibri/shipping_calculator'

module Colibri
  module Calculator::Shipping
    class PriceSack < ShippingCalculator
      preference :minimal_amount, :decimal, default: 0
      preference :normal_amount, :decimal, default: 0
      preference :discount_amount, :decimal, default: 0
      preference :currency, :string, default: ->{ Colibri::Config[:currency] }

      def self.description
        Colibri.t(:shipping_price_sack)
      end

      def compute_package(package)
        content_items = package.contents
        if total(content_items) < self.preferred_minimal_amount
          self.preferred_normal_amount
        else
          self.preferred_discount_amount
        end
      end
    end
  end
end
