module Api
  module V1
    class MindmapsController < ApplicationController
      http_basic_authenticate_with name: "admin", password: "trycatch"

      def index
        @mindmaps = Mindmap.all
      end
    end
  end
end
