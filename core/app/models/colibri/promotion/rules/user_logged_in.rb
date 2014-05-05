module Colibri
  class Promotion
    module Rules
      class UserLoggedIn < PromotionRule
        def applicable?(promotable)
          promotable.is_a?(Colibri::Order)
        end

        def eligible?(order, options = {})
          return order.user.present?
        end
      end
    end
  end
end
