module Colibri
  class ShippingCalculator < Calculator

    def compute_shipment(shipment)
      raise NotImplementedError, "Please implement 'compute_shipment(shipment)' in your calculator: #{self.class.name}"
    end

    def compute_package(package)
      raise NotImplementedError, "Please implement 'compute_package(package)' in your calculator: #{self.class.name}"
    end

    def available?(package)
      true
    end

    private
    def total(content_items)
      content_items.sum { |item| item.quantity * item.variant.price }
    end
  end
end

