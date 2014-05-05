module Colibri
  module Admin
    class ProductPropertiesController < ResourceController
      belongs_to 'colibri/product', :find_by => :slug
      before_filter :find_properties
      before_filter :setup_property, :only => [:index]

      private
        def find_properties
          @properties = Colibri::Property.pluck(:name)
        end

        def setup_property
          @product.product_properties.build
        end
    end
  end
end
