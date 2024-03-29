require_dependency 'colibri/calculator'

module Colibri
  class Calculator::FlexiRate < Calculator
    preference :first_item,      :decimal, default: 0.0
    preference :additional_item, :decimal, default: 0.0
    preference :max_items,       :integer, default: 0
    preference :currency,        :string,  default: ->{ Colibri::Config[:currency] }

    def self.description
      Colibri.t(:flexible_rate)
    end

    def self.available?(object)
      true
    end

    def compute(object)
      sum = 0
      max = self.preferred_max_items.to_i
      items_count = object.line_items.map(&:quantity).sum
      items_count.times do |i|
        if i == 0
          sum += self.preferred_first_item.to_f
        elsif ((max > 0) && (i <= (max - 1))) || (max == 0)
          sum += self.preferred_additional_item.to_f
        end
      end

      sum
    end
  end
end
