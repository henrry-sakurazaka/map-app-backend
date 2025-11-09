# app/controllers/api/v1/omniauth_callbacks_controller.rb
module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      skip_before_action :verify_authenticity_token

      def google
        handle_auth("google")
      end

      def line
        handle_auth("line")
      end

      def apple
        handle_auth("apple")
      end


      private

      def handle_auth(provider)
        auth = request.env["omniauth.auth"]

        user = User.find_or_create_by(provider: provider, uid: auth.uid) do |u|
          u.name      = auth.info.name.presence || "#{provider.capitalize}User"
          u.email     = auth.info.email.presence || "no_email_#{SecureRandom.hex(4)}@example.com"
          u.image_url = auth.info.image.presence
          u.password  = SecureRandom.hex(10)
        end

        token = jwt_token(user)
        redirect_to "http://localhost:5173/oauth-callback?token=#{token}"
      end

      def jwt_token(user)
        JWT.encode(
          { user_id: user.id, exp: 24.hours.from_now.to_i },
          Rails.application.credentials.secret_key_base
        )
      end
    end
  end
end
