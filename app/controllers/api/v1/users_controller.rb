# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        user = Users::Create.new.call(user_params)
        render json: user.to_json, status: :created
      end

      def show
        head :unauthorized unless username

        user = Users::Find.new.call(username:)
        if user
          render json: { user: }.to_json, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      private

      def username
        request.headers['Authorization']&.split(' ')&.last
      end

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
