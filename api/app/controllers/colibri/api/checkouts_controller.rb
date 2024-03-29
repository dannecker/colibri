module Colibri
  module Api
    class CheckoutsController < Colibri::Api::BaseController
      before_filter :associate_user, only: :update

      include Colibri::Core::ControllerHelpers::Auth
      include Colibri::Core::ControllerHelpers::Order
      # This before_filter comes from Colibri::Core::ControllerHelpers::Order
      skip_before_filter :set_current_order

      def create
        authorize! :create, Order
        @order = Colibri::Core::Importer::Order.import(current_api_user, nested_params)
        respond_with(@order, default_template: 'colibri/api/orders/show', status: 201)
      end

      def next
        load_order(true)
        authorize! :update, @order, order_token
        @order.next!
        respond_with(@order, default_template: 'colibri/api/orders/show', status: 200)
      rescue StateMachine::InvalidTransition
        respond_with(@order, default_template: 'colibri/api/orders/could_not_transition', status: 422)
      end

      def advance
        load_order(true)
        authorize! :update, @order, order_token
        while @order.next; end
        respond_with(@order, default_template: 'colibri/api/orders/show', status: 200)
      end

      def show
        redirect_to(api_order_path(params[:id]), status: 301)
      end

      def update
        load_order(true)
        authorize! :update, @order, order_token

        line_items = nested_params.delete('line_items_attributes')

        if @order.update_from_params(params, permitted_checkout_attributes)

          @order.update_line_items(line_items)
          if current_api_user.has_colibri_role?('admin') && user_id.present?
            @order.associate_user!(Colibri.user_class.find(user_id))
          end

          return if after_update_attributes
          state_callback(:after) if @order.next
          respond_with(@order, default_template: 'colibri/api/orders/show')
        else
          invalid_resource!(@order)
        end
      end

      private
        def user_id
          params[:order][:user_id] if params[:order]
        end

        def nested_params
          map_nested_attributes_keys Order, params[:order] || {}
        end

        # Should be overriden if you have areas of your checkout that don't match
        # up to a step within checkout_steps, such as a registration step
        def skip_state_validation?
          false
        end

        def load_order(lock = false)
          @order = Colibri::Order.lock(lock).find_by!(number: params[:id])
          raise_insufficient_quantity and return if @order.insufficient_stock_lines.present?
          @order.state = params[:state] if params[:state]
          state_callback(:before)
        end

        def ip_address
          ''
        end

        def raise_insufficient_quantity
          respond_with(@order, default_template: 'colibri/api/orders/insufficient_quantity')
        end

        def state_callback(before_or_after = :before)
          method_name = :"#{before_or_after}_#{@order.state}"
          send(method_name) if respond_to?(method_name, true)
        end

        def before_payment
          @order.payments.destroy_all if request.put?
        end

        def next!(options={})
          if @order.valid? && @order.next
            render 'colibri/api/orders/show', status: options[:status] || 200
          else
            render 'colibri/api/orders/could_not_transition', status: 422
          end
        end

        def after_update_attributes
          if nested_params && nested_params[:coupon_code].present?
            handler = PromotionHandler::Coupon.new(@order).apply

            if handler.error.present?
              @coupon_message = handler.error
              respond_with(@order, default_template: 'colibri/api/orders/could_not_apply_coupon')
              return true
            end
          end
          false
        end

        def order_id
          super || params[:id]
        end
    end
  end
end
