module Colibri
  module Admin
    class VariantsIncludingMasterController < VariantsController

      def model_class
        Colibri::Variant
      end

      def object_name
        "variant"
      end

    end
  end
end
