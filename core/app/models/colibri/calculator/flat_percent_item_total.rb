require_dependency 'colibri/calculator'

module Colibri
  class Calculator::FlatPercentItemTotal < Calculator
    preference :flat_percent, :decimal, default: 0

    def self.description
      Colibri.t(:flat_percent)
    end

    def compute(line_item)
      value = line_item.amount * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
      (value * 100).round.to_f / 100
    end
  end
end
