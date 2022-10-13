# frozen_string_literal: true

module Api
  module V1
      class UsersController < ApiController
        before_action :doorkeeper_authorize!
        before_action :current_user
        respond_to    :json

        # GET /me.json
        def index
          users = User.all
          render json:  users
        end
        def show
          @user = User.find(params[:id])
          render json: @user
        end

        def update_deactivate
          user = User.find_by_id(user_params[:id])

          client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
          unless client_app
            return render json: { error: 'Client Not Found. Check Provided Client Id.' },
                          status: :unauthorized
          end
          allowed_params = user_params.except(:client_id, :client_secret)

          if user.role == 'user'
            if user.update(allowed_params)
              render json: user, status: :ok
            else
              render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
          else
            render json: { error: 'cannot deactivate admin' }, status: :not_acceptable
          end

        end

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

        private
        def user_params
          params.permit(:id, :deactivated, :client_id)
        end
      end
  end
end
