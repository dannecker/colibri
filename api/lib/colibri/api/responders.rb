require 'colibri/api/responders/rabl_template'

module Colibri
  module Api
    module Responders
      class AppResponder < ActionController::Responder
        include RablTemplate
      end
    end
  end
end
