module Colibri
  module Core
    module ControllerHelpers
      module Store
        extend ActiveSupport::Concern

        included do

          def current_store
            @current_store ||= Colibri::Store.current(request.env['SERVER_NAME'])
          end
          helper_method :current_store

        end

      end
    end
  end
end
