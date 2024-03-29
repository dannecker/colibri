module Colibri
  module Api
    module Responders
      module RablTemplate
        def to_format
          if template
            render template, :status => options[:status] || 200
          else
            super
          end

        rescue ActionView::MissingTemplate => e
          api_behavior(e)
        end

        def template
          request.headers['X-Colibri-Template'] || controller.params[:template] || options[:default_template]
        end

        def api_behavior(error)
          if controller.params[:action] == "destroy"
            # Render a blank template
            super
          else
            # Do nothing and fallback to the default template
          end
        end
      end
    end
  end
end
