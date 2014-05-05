module Colibri
  module Admin
    class TaxSettingsController < Colibri::Admin::BaseController

      def update
        Colibri::Config.set(params[:preferences])

        respond_to do |format|
          format.html {
            redirect_to edit_admin_tax_settings_path
          }
        end
      end

    end
  end
end
