module Colibri
  class Promotion
    module Rules
      class FirstOrder < PromotionRule
        attr_reader :user, :email

        def applicable?(promotable)
          promotable.is_a?(Colibri::Order)
        end

        def eligible?(order, options = {})
          @user = order.try(:user) || options[:user]
          @email = order.email

          if user || email
            completed_orders.blank? || (completed_orders.first == order)
          else
            false
          end
        end

        private
          def completed_orders
            user ? user.orders.complete : orders_by_email
          end

          def orders_by_email
            Colibri::Order.where(email: email).complete
          end
      end
    end
  end
end
