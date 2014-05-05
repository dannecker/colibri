# TODO: Deprecate this class.
# This calculator will be removed in future versions of Colibri.
# The only case where it was used was for Free Shipping Promotions.
# There is now a Promotion Action which deals with these types of promotions instead.
module Colibri
  class Calculator::FreeShipping < Calculator
    def self.description
      Colibri.t(:free_shipping)
    end

    def compute(object)
      if object.is_a?(Array)
        return if object.empty?
        order = object.first.order
      else
        order = object
      end

      order.ship_total
    end
  end
end
