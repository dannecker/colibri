module Colibri
  module Api
    class PropertiesController < Colibri::Api::BaseController

      before_filter :find_property, only: [:show, :update, :destroy]

      def index
        @properties = Colibri::Property.accessible_by(current_ability, :read)

        if params[:ids]
          @properties = @properties.where(:id => params[:ids].split(","))
        else
          @properties = @properties.ransack(params[:q]).result
        end

        @properties = @properties.page(params[:page]).per(params[:per_page])
        respond_with(@properties)
      end

      def show
        respond_with(@property)
      end

      def new
      end

      def create
        authorize! :create, Property
        @property = Colibri::Property.new(property_params)
        if @property.save
          respond_with(@property, status: 201, default_template: :show)
        else
          invalid_resource!(@property)
        end
      end

      def update
        if @property
          authorize! :update, @property
          @property.update_attributes(property_params)
          respond_with(@property, status: 200, default_template: :show)
        else
          invalid_resource!(@property)
        end
      end

      def destroy
        if @property
          authorize! :destroy, @property
          @property.destroy
          respond_with(@property, status: 204)
        else
          invalid_resource!(@property)
        end
      end

      private

        def find_property
          @property = Colibri::Property.accessible_by(current_ability, :read).find(params[:id])
        rescue ActiveRecord::RecordNotFound
          @property = Colibri::Property.accessible_by(current_ability, :read).find_by!(name: params[:id])
        end

        def property_params
          params.require(:property).permit(permitted_property_attributes)
        end
    end
  end
end
