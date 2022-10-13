# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < ApiController
        skip_before_action :doorkeeper_authorize!, only: %i[create]

        def generate_refresh_token
          loop do
            # generate a random token string and return it
            # unless there is already another token with the same string
            token = SecureRandom.hex(32)
            break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
          end
        end

        def render_user(user, client_app, token_type = 'Bearer')
          access_token = Doorkeeper::AccessToken.create(resource_owner_id: user.id,
                                                        application_id: client_app.id,
                                                        refresh_token: generate_refresh_token,
                                                        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
                                                        scopes: '')

          {
            id: user.id,
            email: user.email,
            role: user.role,
            access_token: access_token.token,
            token_type: token_type,
            expires_in: access_token.expires_in,
            refresh_token: access_token.refresh_token,
            created_at: user.created_at.iso8601
          }
          end

        def create
          client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
          unless client_app
            return render json: { error: 'Client Not Found. Check Provided Client Id.' },
                          status: :unauthorized
          end

          allowed_params = user_params.except(:client_id)
          user = User.new(allowed_params)

          if user.save
            render json: render_user(user, client_app), status: :ok
          else

            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end


        private

        def doorkeeper_authorize!
          # code here
        end

        def user_params
          params.permit(:first_name, :last_name, :phone_number, :email, :password, :role, :client_id)
        end
      end
    end
  end
end
