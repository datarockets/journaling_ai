# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate!, only: [:create]

      def create
        user = Users::Create.new.call(user_params)
        render json: user.to_json, status: :created
      end

      def show
        render json: { user: current_user }.to_json, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(
          :username,
          :name,
          :last_name,
          :experience,
          :goals
        )
      end
    end
  end
end
