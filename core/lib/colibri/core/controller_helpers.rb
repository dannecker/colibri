require 'colibri/core/controller_helpers/common'
require 'colibri/core/controller_helpers/auth'
require 'colibri/core/controller_helpers/respond_with'
require 'colibri/core/controller_helpers/order'

module Colibri
  module Core
    module ControllerHelpers
      def self.included(klass)
        klass.class_eval do
          include Colibri::Core::ControllerHelpers::Common
          include Colibri::Core::ControllerHelpers::Auth
          include Colibri::Core::ControllerHelpers::RespondWith
          include Colibri::Core::ControllerHelpers::Order
        end
      end
    end
  end
end
