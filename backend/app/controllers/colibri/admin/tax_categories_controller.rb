module Colibri
  module Admin
    class TaxCategoriesController < ResourceController
      def destroy
        if @object.destroy
          flash[:success] = flash_message_for(@object, :successfully_removed)
          respond_with(@object) do |format|
            format.html { redirect_to collection_url }
            format.js   { render :partial => "colibri/admin/shared/destroy" }
          end
        else
          respond_with(@object) do |format|
            format.html { redirect_to collection_url }
          end
        end
      end
    end
  end
end
