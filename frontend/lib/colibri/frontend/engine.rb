module Colibri
  module Frontend
    class Engine < ::Rails::Engine
      config.middleware.use "Colibri::Frontend::Middleware::SeoAssist"

      # sets the manifests / assets to be precompiled, even when initialize_on_precompile is false
      initializer "colibri.assets.precompile", :group => :all do |app|
        app.config.assets.precompile += %w[
          colibri/frontend/all*
        ]
      end

      initializer "colibri.frontend.environment", :before => :load_config_initializers do |app|
        Colibri::Frontend::Config = Colibri::FrontendConfiguration.new
      end
    end
  end
end
