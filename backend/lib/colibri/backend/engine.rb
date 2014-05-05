module Colibri
  module Backend
    class Engine < ::Rails::Engine
      config.middleware.use "Colibri::Backend::Middleware::SeoAssist"

      initializer "colibri.backend.environment", :before => :load_config_initializers do |app|
        Colibri::Backend::Config = Colibri::BackendConfiguration.new
      end

      # filter sensitive information during logging
      initializer "colibri.params.filter" do |app|
        app.config.filter_parameters += [:password, :password_confirmation, :number]
      end

      # sets the manifests / assets to be precompiled, even when initialize_on_precompile is false
      initializer "colibri.assets.precompile", :group => :all do |app|
        app.config.assets.precompile += %w[
          colibri/backend/all*
          colibri/backend/orders/edit_form.js
          colibri/backend/address_states.js
          jqPlot/excanvas.min.js
          colibri/backend/images/new.js
          jquery.jstree/themes/apple/*
          fontawesome-webfont*
          select2_locale*
          jquery.alerts/images/*
        ]
      end
    end
  end
end
