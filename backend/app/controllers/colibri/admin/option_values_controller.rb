module Colibri
  module Admin
    class OptionValuesController < Colibri::Admin::BaseController
      def destroy
        option_value = Colibri::OptionValue.find(params[:id])
        option_value.destroy
        render :text => nil
      end
    end
  end
end
