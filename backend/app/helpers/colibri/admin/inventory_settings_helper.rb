module Colibri
  module Admin
    module InventorySettingsHelper
      def show_not(true_or_false)
        true_or_false ? '' : Colibri.t(:not)
      end
    end
  end
end
