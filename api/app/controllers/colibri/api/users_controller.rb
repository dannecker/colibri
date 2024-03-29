module Colibri
  module Api
    class UsersController < Colibri::Api::BaseController

      def index
        @users = Colibri.user_class.accessible_by(current_ability,:read).ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
        respond_with(@users)
      end

      def show
        respond_with(user)
      end

      def new
      end

      def create
        authorize! :create, Colibri.user_class
        @user = Colibri.user_class.new(user_params)
        if @user.save
          respond_with(@user, :status => 201, :default_template => :show)
        else
          invalid_resource!(@user)
        end
      end

      def update
        authorize! :update, user
        if user.update_attributes(user_params)
          respond_with(user, :status => 200, :default_template => :show)
        else
          invalid_resource!(user)
        end
      end

      def destroy
        authorize! :destroy, user
        user.destroy
        respond_with(user, :status => 204)
      end

      private

      def user
        @user ||= Colibri.user_class.accessible_by(current_ability, :read).find(params[:id])
      end

      def user_params
        params.require(:user).permit(permitted_user_attributes)
      end
    end
  end
end
