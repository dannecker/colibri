module Colibri
  module Core
    module ControllerHelpers
      module Auth
        extend ActiveSupport::Concern

        included do
          helper_method :try_colibri_current_user

          rescue_from CanCan::AccessDenied do |exception|
            unauthorized
          end
        end

        # Needs to be overriden so that we use Colibri's Ability rather than anyone else's.
        def current_ability
          @current_ability ||= Colibri::Ability.new(try_colibri_current_user)
        end

        # Redirect as appropriate when an access request fails.  The default action is to redirect to the login screen.
        # Override this method in your controllers if you want to have special behavior in case the user is not authorized
        # to access the requested action.  For example, a popup window might simply close itself.
        def unauthorized
          if try_colibri_current_user
            flash[:error] = Colibri.t(:authorization_failure)
            redirect_to '/unauthorized'
          else
            store_location
            if respond_to?(:colibri_login_path)
              redirect_to colibri_login_path
            else
              redirect_to colibri.respond_to?(:root_path) ? colibri.root_path : root_path
            end
          end
        end

        def store_location
          # disallow return to login, logout, signup pages
          authentication_routes = [:colibri_signup_path, :colibri_login_path, :colibri_logout_path]
          disallowed_urls = []
          authentication_routes.each do |route|
            if respond_to?(route)
              disallowed_urls << send(route)
            end
          end

          disallowed_urls.map!{ |url| url[/\/\w+$/] }
          unless disallowed_urls.include?(request.fullpath)
            session['colibri_user_return_to'] = request.fullpath.gsub('//', '/')
          end
        end

        # proxy method to *possible* colibri_current_user method
        # Authentication extensions (such as colibri_auth_devise) are meant to provide colibri_current_user
        def try_colibri_current_user
          # This one will be defined by apps looking to hook into Colibri
          # As per authentication_helpers.rb
          if respond_to?(:colibri_current_user)
            colibri_current_user
          # This one will be defined by Devise
          elsif respond_to?(:current_colibri_user)
            current_colibri_user
          else
            nil
          end
        end

        def redirect_back_or_default(default)
          redirect_to(session["colibri_user_return_to"] || default)
          session["colibri_user_return_to"] = nil
        end
      end
    end
  end
end
