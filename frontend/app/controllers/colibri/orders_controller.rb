module Colibri
  class OrdersController < Colibri::StoreController
    ssl_required :show

    before_filter :check_authorization
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'colibri/products', 'colibri/orders'

    respond_to :html

    before_filter :assign_order_with_lock, only: :update
    before_filter :apply_coupon_code, only: :update
    skip_before_filter :verify_authenticity_token

    def show
      @order = Order.find_by_number!(params[:id])
    end

    def update
      if @order.contents.update_cart(order_params)
        respond_with(@order) do |format|
          format.html do
            if params.has_key?(:checkout)
              @order.next if @order.cart?
              redirect_to checkout_state_path(@order.checkout_steps.first)
            else
              redirect_to cart_path
            end
          end
        end
      else
        respond_with(@order)
      end
    end

    # Shows the current incomplete order from the session
    def edit
      @order = current_order || Order.new
      associate_user
      if stale?(current_order)
        respond_with(current_order)
      end
    end

    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      populator = Colibri::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
      if populator.populate(params[:variant_id], params[:quantity])
        current_order.ensure_updated_shipments

        respond_with(@order) do |format|
          format.html { redirect_to cart_path }
        end
      else
        flash[:error] = populator.errors.full_messages.join(" ")
        redirect_to :back
      end
    end

    def empty
      if @order = current_order
        @order.empty!
      end

      redirect_to colibri.cart_path
    end

    def accurate_title
      if @order && @order.completed?
        Colibri.t(:order_number, :number => @order.number)
      else
        Colibri.t(:shopping_cart)
      end
    end

    def check_authorization
      session[:access_token] ||= params[:token]
      order = Colibri::Order.find_by_number(params[:id]) || current_order

      if order
        authorize! :edit, order, session[:access_token]
      else
        authorize! :create, Colibri::Order
      end
    end

    private

      def order_params
        if params[:order]
          params[:order].permit(*permitted_order_attributes)
        else
          {}
        end
      end

      def assign_order_with_lock
        @order = current_order(lock: true)
        unless @order
          flash[:error] = Colibri.t(:order_not_found)
          redirect_to root_path and return
        end
      end
  end
end
