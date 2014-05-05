module Colibri
  module Admin
    class UsersController < ResourceController
      rescue_from Colibri::Core::DestroyWithOrdersError, :with => :user_destroy_with_orders_error

      after_filter :sign_in_if_change_own_password, :only => :update

      # http://colibricommerce.com/blog/2010/11/02/json-hijacking-vulnerability/
      before_filter :check_json_authenticity, :only => :index
      before_filter :load_roles

      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def show
        redirect_to edit_admin_user_path(@user)
      end

      def create
        if params[:user]
          roles = params[:user].delete("colibri_role_ids")
        end

        @user = Colibri.user_class.new(user_params)
        if @user.save

          if roles
            @user.colibri_roles = roles.reject(&:blank?).collect{|r| Colibri::Role.find(r)}
          end

          flash.now[:success] = Colibri.t(:created_successfully)
          render :edit
        else
          render :new
        end
      end

      def update
        if params[:user]
          roles = params[:user].delete("colibri_role_ids")
        end

        if @user.update_attributes(user_params)
          if roles
            @user.colibri_roles = roles.reject(&:blank?).collect{|r| Colibri::Role.find(r)}
          end
          flash.now[:success] = Colibri.t(:account_updated)
        end

        render :edit
      end

      def addresses
        if request.put?
          if @user.update_attributes(user_params)
            flash.now[:success] = Colibri.t(:account_updated)
          end

          render :addresses
        end
      end

      def orders
        params[:q] ||= {}
        @search = Colibri::Order.ransack(params[:q].merge(user_id_eq: @user.id))
        @orders = @search.result.page(params[:page]).per(Colibri::Config[:admin_products_per_page])
      end

      def items
        params[:q] ||= {}
        @search = Colibri::Order.includes(
          line_items: {
            variant: [:product, { option_values: :option_type }]
          }).ransack(params[:q].merge(user_id_eq: @user.id))
        @orders = @search.result.page(params[:page]).per(Colibri::Config[:admin_products_per_page])
      end

      def generate_api_key
        if @user.generate_colibri_api_key!
          flash[:success] = Colibri.t('api.key_generated')
        end
        redirect_to edit_admin_user_path(@user)
      end

      def clear_api_key
        if @user.clear_colibri_api_key!
          flash[:success] = Colibri.t('api.key_cleared')
        end
        redirect_to edit_admin_user_path(@user)
      end

      def model_class
        Colibri.user_class
      end

      protected

        def collection
          return @collection if @collection.present?
          if request.xhr? && params[:q].present?
            @collection = Colibri.user_class.includes(:bill_address, :ship_address)
                              .where("colibri_users.email #{LIKE} :search
                                     OR (colibri_addresses.firstname #{LIKE} :search AND colibri_addresses.id = colibri_users.bill_address_id)
                                     OR (colibri_addresses.lastname  #{LIKE} :search AND colibri_addresses.id = colibri_users.bill_address_id)
                                     OR (colibri_addresses.firstname #{LIKE} :search AND colibri_addresses.id = colibri_users.ship_address_id)
                                     OR (colibri_addresses.lastname  #{LIKE} :search AND colibri_addresses.id = colibri_users.ship_address_id)",
                                    { :search => "#{params[:q].strip}%" })
                              .limit(params[:limit] || 100)
          else
            @search = Colibri.user_class.ransack(params[:q])
            @collection = @search.result.page(params[:page]).per(Colibri::Config[:admin_products_per_page])
          end
        end

      private
        def user_params
          params.require(:user).permit(PermittedAttributes.user_attributes |
                                       [:colibri_role_ids,
                                        ship_address_attributes: PermittedAttributes.address_attributes,
                                        bill_address_attributes: PermittedAttributes.address_attributes])
        end

        # handling raise from Colibri::Admin::ResourceController#destroy
        def user_destroy_with_orders_error
          invoke_callbacks(:destroy, :fails)
          render :status => :forbidden, :text => Colibri.t(:error_user_destroy_with_orders)
        end

        # Allow different formats of json data to suit different ajax calls
        def json_data
          json_format = params[:json_format] or 'default'
          case json_format
          when 'basic'
            collection.map { |u| { 'id' => u.id, 'name' => u.email } }.to_json
          else
            address_fields = [:firstname, :lastname, :address1, :address2, :city, :zipcode, :phone, :state_name, :state_id, :country_id]
            includes = { :only => address_fields , :include => { :state => { :only => :name }, :country => { :only => :name } } }

            collection.to_json(:only => [:id, :email], :include =>
                               { :bill_address => includes, :ship_address => includes })
          end
        end

        def sign_in_if_change_own_password
          if try_colibri_current_user == @user && @user.password.present?
            sign_in(@user, :event => :authentication, :bypass => true)
          end
        end

        def load_roles
          @roles = Colibri::Role.all
        end
    end
  end
end
