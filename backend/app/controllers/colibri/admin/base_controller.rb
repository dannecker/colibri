module Colibri
  module Admin
    class BaseController < Colibri::BaseController
      ssl_required

      helper 'colibri/admin/navigation'
      helper 'colibri/admin/tables'
      layout '/colibri/layouts/admin'

      before_filter :check_alerts
      before_filter :authorize_admin

      protected

        def action
          params[:action].to_sym
        end

        def authorize_admin
          if respond_to?(:model_class, true) && model_class
            record = model_class
          else
            record = controller_name.to_sym
          end
          authorize! :admin, record
          authorize! action, record
        end

        # Need to generate an API key for a user due to some backend actions
        # requiring authentication to the Colibri API
        def generate_admin_api_key
          if (user = try_colibri_current_user) && user.colibri_api_key.blank?
            user.generate_colibri_api_key!
          end
        end

        def check_alerts
          return unless should_check_alerts?
          unless session.has_key? :alerts
            session[:alerts] = Colibri::Alert.current(request.host)
            filter_dismissed_alerts
            Colibri::Config.set :last_check_for_colibri_alerts => DateTime.now.to_s
          end
        end

        def should_check_alerts?
          return false if !Rails.env.production? || !Colibri::Config[:check_for_colibri_alerts]

          last_check = Colibri::Config[:last_check_for_colibri_alerts]
          return true if last_check.blank?

          DateTime.parse(last_check) < 12.hours.ago
        end

        def flash_message_for(object, event_sym)
          resource_desc  = object.class.model_name.human
          resource_desc += " \"#{object.name}\"" if object.respond_to?(:name) && object.name.present?
          Colibri.t(event_sym, :resource => resource_desc)
        end

        def render_js_for_destroy
          render :partial => '/colibri/admin/shared/destroy'
        end

        # Index request for JSON needs to pass a CSRF token in order to prevent JSON Hijacking
        def check_json_authenticity
          return unless request.format.js? or request.format.json?
          return unless protect_against_forgery?
          auth_token = params[request_forgery_protection_token]
          unless (auth_token and form_authenticity_token == URI.unescape(auth_token))
            raise(ActionController::InvalidAuthenticityToken)
          end
        end

        def filter_dismissed_alerts
          return unless session[:alerts]
          dismissed = (Colibri::Config[:dismissed_colibri_alerts] || '').split(',')
          # If it's a string, something has gone wrong with the alerts service. Ignore it.
          if session[:alerts].is_a?(String)
            session[:alerts] = nil
          else
            session[:alerts].reject! { |a| dismissed.include? a["id"].to_s }
          end
        end

        def config_locale
          Colibri::Backend::Config[:locale]
        end

    end
  end
end
