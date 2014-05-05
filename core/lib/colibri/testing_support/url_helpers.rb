module Colibri
  module TestingSupport
    module UrlHelpers
      def colibri
        Colibri::Core::Engine.routes.url_helpers
      end
    end
  end
end
