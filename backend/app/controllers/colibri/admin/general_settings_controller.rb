module Colibri
  module Admin
    class GeneralSettingsController < Colibri::Admin::BaseController
      before_filter :set_store

      def edit
        @preferences_security = [:allow_ssl_in_production,
                        :allow_ssl_in_staging, :allow_ssl_in_development_and_test,
                        :check_for_colibri_alerts]
        @preferences_currency = [:display_currency, :hide_cents]
      end

      def update
        params.each do |name, value|
          next unless Colibri::Config.has_preference? name
          Colibri::Config[name] = value
        end

        current_store.update_attributes store_params

        flash[:success] = Colibri.t(:successfully_updated, :resource => Colibri.t(:general_settings))
        redirect_to edit_admin_general_settings_path
      end

      def dismiss_alert
        if request.xhr? and params[:alert_id]
          dismissed = Colibri::Config[:dismissed_colibri_alerts] || ''
          Colibri::Config.set :dismissed_colibri_alerts => dismissed.split(',').push(params[:alert_id]).join(',')
          filter_dismissed_alerts
          render :nothing => true
        end
      end

      private
      def store_params
        params.require(:store).permit(permitted_params)
      end

      def permitted_params
        Colibri::PermittedAttributes.store_attributes
      end

      def set_store
        @store = current_store
      end
    end
  end
end
