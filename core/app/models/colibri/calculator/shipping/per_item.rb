require_dependency 'colibri/shipping_calculator'

module Colibri
  module Calculator::Shipping
    class PerItem < ShippingCalculator
      preference :amount, :decimal, default: 0
      preference :currency, :string, default: ->{ Colibri::Config[:currency] }

      def self.description
        Colibri.t(:shipping_flat_rate_per_item)
      end

      def compute_package(package)
        content_items = package.contents
        self.preferred_amount * content_items.sum { |item| item.quantity }
      end
    end
  end
end
