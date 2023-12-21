# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate!
  skip_before_action :verify_authenticity_token

  attr_reader :current_user

  def authenticate!
    @current_user = Users::Find.new.call(username:)

    render json: {errors: ["User is not authorized"]}, status: :unauthorized unless current_user
  end

  private

  def username
    request.headers["Authorization"]&.split("Bearer ")&.last
  end
end
