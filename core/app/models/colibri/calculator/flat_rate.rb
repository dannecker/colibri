require_dependency 'colibri/calculator'

module Colibri
  class Calculator::FlatRate < Calculator
    preference :amount, :decimal, default: 0
    preference :currency, :string, default: ->{ Colibri::Config[:currency] }

    def self.description
      Colibri.t(:flat_rate_per_order)
    end

    def compute(object=nil)
      self.preferred_amount
    end
  end
end
