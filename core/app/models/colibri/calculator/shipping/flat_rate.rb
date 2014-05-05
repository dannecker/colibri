require_dependency 'colibri/shipping_calculator'

module Colibri
  module Calculator::Shipping
    class FlatRate < ShippingCalculator
      preference :amount, :decimal, default: 0
      preference :currency, :string, default: ->{ Colibri::Config[:currency] }

      def self.description
        Colibri.t(:shipping_flat_rate_per_order)
      end

      def compute_package(package)
        self.preferred_amount
      end
    end
  end
end
