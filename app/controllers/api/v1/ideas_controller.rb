module Api
  module V1
    class IdeasController < ApplicationController
      http_basic_authenticate_with name: "admin", password: "trycatch"
      before_action :authenticate_user!

      def index
        @ideas = Idea.all
      end
    end
  end
end
