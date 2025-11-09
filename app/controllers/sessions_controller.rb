module Api
  module V1
    class SessionsController < ApplicationController
      # POST /api/v1/auth/register
      def register
        user = User.new(register_params)
        if user.save
          token = jwt_encode(user_id: user.id)
          render json: { token: token, user: user_response(user) }
        else
          render json: { errors: user.errors.full_messages }, status: :unauthorized
        end
      end

      # POST /api/v1/auth/login
      def create
        puts "=== Incoming params ==="
        puts params.inspect
        puts "======================"

        user = User.find_by(email: params[:email]&.downcase)
        if user&.authenticate(params[:password])
          token = jwt_encode({ user_id: user.id })
          render json: { token: token, user: user_response(user) }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def register_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def user_response(user)
        {
          id: user.id,
          name: user.name,
          email: user.email,
          image_url: user.image_url,
          provider: user.provider
        }
      end

      # JWT ヘルパー
      def jwt_encode(payload, exp = 7.days.from_now.to_i)
        payload[:exp] = exp
        JWT.encode(payload, Rails.application.secret_key_base)
      end
    end
  end
end
