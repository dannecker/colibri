module Colibri
  class ShippingRate < Colibri::Base
    belongs_to :shipment, class_name: 'Colibri::Shipment'
    belongs_to :shipping_method, class_name: 'Colibri::ShippingMethod', inverse_of: :shipping_rates
    belongs_to :tax_rate, class_name: 'Colibri::TaxRate'

    delegate :order, :currency, to: :shipment
    delegate :name, to: :shipping_method

    def display_base_price
      Colibri::Money.new(cost, currency: currency)
    end

    def calculate_tax_amount
      tax_rate.calculator.compute_shipping_rate(self)
    end

    def display_price
      price = display_base_price.to_s
      if tax_rate
        tax_amount = calculate_tax_amount
        if tax_amount != 0
          if tax_rate.included_in_price?
            if tax_amount > 0
              amount = "#{display_tax_amount(tax_amount)} #{tax_rate.name}"
              price += " (incl. #{amount})"
            else
              amount = "#{display_tax_amount(tax_amount*-1)} #{tax_rate.name}"
              price += " (excl. #{amount})"
            end
          else
            amount = "#{display_tax_amount(tax_amount)} #{tax_rate.name}"
            price += " (+ #{amount})"
          end
        end
      end
      price
    end
    alias_method :display_cost, :display_price

    def display_tax_amount(tax_amount)
      Colibri::Money.new(tax_amount, currency: currency)
    end

    def shipping_method
      Colibri::ShippingMethod.unscoped { super }
    end

    def tax_rate
      Colibri::TaxRate.unscoped { super }
    end
  end
end
