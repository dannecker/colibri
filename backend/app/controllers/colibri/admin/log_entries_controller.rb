module Colibri
  module Admin
    class LogEntriesController < Colibri::Admin::BaseController
      before_filter :find_order_and_payment

      def index
        @log_entries = @payment.log_entries
      end


      private

      def find_order_and_payment
        @order = Colibri::Order.where(:number => params[:order_id]).first!
        @payment = @order.payments.find(params[:payment_id])
      end
    end
  end
end
