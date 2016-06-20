module Api
  module V1
    class MindmapsController < ApplicationController
       http_basic_authenticate_with name: "admin", password: "trycatch"
       before_action :authenticate_user!

      def index
        @mindmaps = Mindmap.all
      end

      def show
        @mindmap = Mindmap.find(params[:id])
      end

      def create
        return head :unauthorized if guest?
        mindmap = Mindmap.new(mindmap_params)
        if mindmap.save
          head :created
        else
          head :not_modified
        end
      end

      def update
        mindmap = Mindmap.find(params[:id])
        return head :unauthorized unless is_admin_or_belongs_to_user?(mindmap)
        if mindmap.update_attributes(mindmap_params)
          head :ok
        else
          head :not_modified
        end
      end

      def destroy
        mindmap = Mindmap.find(params[:id])
        return head :unauthorized unless is_admin_or_belongs_to_user?(mindmap)
        if mindmap.destroy!
          head :ok
        else
          head :not_modified
        end
      end

      private

      def mindmap_params
       params.require(:mindmap).permit(:title, :description, :user_id, :private)
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
