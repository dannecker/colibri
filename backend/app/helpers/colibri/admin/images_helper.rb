module Colibri
  module Admin
    module ImagesHelper
      def options_text_for(image)
        if image.viewable.is_a?(Colibri::Variant)
          if image.viewable.is_master?
            Colibri.t(:all)
          else
            image.viewable.sku_and_options_text
          end
        else
          Colibri.t(:all)
        end
      end
    end
  end
end

