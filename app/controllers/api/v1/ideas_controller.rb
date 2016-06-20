module Api
  module V1
    class IdeasController < ApplicationController
      include ActionController::HttpAuthentication::Basic::ControllerMethods
      http_basic_authenticate_with name: "admin", password: "trycatch"
      before_action :authenticate_user!

      def index
        @ideas = Idea.all
      end

      def show
        @idea = Idea.find(params[:id])
      end

      def create
        return head :unauthorized if guest?
        idea = Idea.new(idea_params)
        if idea.save
          head :created
        else
          head :not_modified
        end
      end

      def update
        idea = Idea.find(params[:id])
        return head :unauthorized unless is_admin_or_belongs_to_user?(idea)
        if idea.update_attributes(idea_params)
          head :ok
        else
          head :not_modified
        end
      end

      def destroy
        idea = Idea.find(params[:id])
        return head :unauthorized unless is_admin_or_belongs_to_user?(idea)
        if idea.destroy!
          head :ok
        else
          head :not_modified
        end
      end

      private

      def idea_params
       params.require(:idea).permit(:title, :description, :user_id, :private)
      end

      def is_admin_or_belongs_to_user?(instance)
        admin? || (user? && instance.user_id == current_user.id)
      end

      def admin?
        current_user.role.name == RoleName.enum(:admin)
      end

      def guest?
        current_user.role.name == RoleName.enum(:guest)
      end

      def user?
        current_user.role.name == RoleName.enum(:user)
      end
    end
  end
end
