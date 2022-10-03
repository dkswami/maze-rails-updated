# frozen_string_literal: true

module Api
  module V1
      class UsersController < ApiController
        before_action :doorkeeper_authorize!
        before_action :current_user
        respond_to    :json

        # GET /me.json
        def me
          if @current_user.nil?
            render json: { error: 'Not Authorized' }, status: :unauthorized
          else
            render json: {
              id: @current_user.id,
              first_name: @current_user.first_name,
              last_name: @current_user.last_name,
              phone_number: @current_user.phone_number,
              email: @current_user.email,
              role: @current_user.role,
              created_at: @current_user.created_at.iso8601
            }, status: :ok
          end
        end
      end
  end
end
