# this clas was inspired (heavily) from the mephisto admin architecture
module Colibri
  module Admin
    class OverviewController < Colibri::Admin::BaseController
      def index
        @users = User.all
      end

    end
  end
end
