module Colibri
  module Core
    module UserPaymentSource
      extend ActiveSupport::Concern

      included do
        has_many :credit_cards, class_name: "Colibri::CreditCard", foreign_key: :user_id

        def payment_sources
          credit_cards.with_payment_profile
        end

        def drop_payment_source(source)
          gateway = source.payment_method
          gateway.disable_customer_profile(source)
        end
      end
    end
  end
end
