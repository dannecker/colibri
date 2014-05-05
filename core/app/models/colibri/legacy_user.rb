# Default implementation of User.  This class is intended to be modified by extensions (ex. colibri_auth_devise)
module Colibri
  class LegacyUser < Colibri::Base
    include Core::UserAddress
    include Core::UserPaymentSource

    self.table_name = 'colibri_users'

    has_many :orders, foreign_key: :user_id

    before_destroy :check_completed_orders

    def has_colibri_role?(role)
      true
    end

    attr_accessor :password
    attr_accessor :password_confirmation

    private

      def check_completed_orders
        raise Colibri::Core::DestroyWithOrdersError if orders.complete.present?
      end
  end
end
