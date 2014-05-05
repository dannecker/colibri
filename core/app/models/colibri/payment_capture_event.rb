module Colibri
  class PaymentCaptureEvent < Colibri::Base
    belongs_to :payment, class_name: 'Colibri::Payment'

    def display_amount
      Colibri::Money.new(amount, { currency: payment.currency })
    end
  end
end
