module Api
  module V1
    module Auth
      class AuthController < ApplicationController
        JWT_SECRET = Rails.application.secret_key_base

        skip_before_action :authenticate_user!, only: [ :guest, :login ]
        before_action :authenticate_user!, only: [ :current ]

        def current
          render json: current_user ? {
            email: current_user.email
          } : {}
        end

        def authenticate_user!
          header = request.headers["Authorization"]
          return @current_user = nil unless header

          token = header.split(" ").last

          begin
            decoded = JWT.decode(token, JWT_SECRET)[0]
            @current_user = User.find_by(id: decoded["user_id"])
          rescue
            @current_user = nil
          end
        end

        def login
          user = User.find_by(email: params[:email])

          if user&.authenticate(params[:password])
            render json: {
              user: user_json(user),
              token: generate_jwt(user)
            }
          else
            render json: { error: "Invalid email or password" }, status: :unauthorized
          end
        end

        def register
          user = User.new(user_params)

          if user.save
            render json: {
              user: user_json(user),
              token: generate_jwt(user)
            }, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def guest
          user = User.create_guest!
          render json: { user: user_json(user), token: generate_jwt(user) }
        end

        private

        def generate_jwt(user)
          payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
          JWT.encode(payload, JWT_SECRET)
        end

        def user_json(user)
          {
            id: user.id,
            name: user.name,
            email: user.email,
            provider: user.provider,
            uid: user.uid,
            image_url: user.image_url
          }
        end

        def current_user
          @current_user
        end

        def user_params
          params.permit(:email, :password, :name)
        end
      end
    end
  end
end
