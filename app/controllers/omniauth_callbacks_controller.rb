
module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      skip_before_action :verify_authenticity_token

      # OAuth コールバック
      def callback
        auth = request.env['omniauth.auth']
        provider = params[:provider]

        user = User.find_or_create_by(provider: provider, uid: auth.uid) do |u|
          u.name      = auth.info.name.presence || "#{provider.capitalize}User"
          u.email     = auth.info.email.presence || "no_email_#{SecureRandom.hex(4)}@example.com"
          u.image_url = auth.info.image.presence
          u.password  = SecureRandom.hex(10)
        end

        token = JWT.encode(
          { user_id: user.id, exp: 24.hours.from_now.to_i },
          Rails.application.secret_key_base
        )

        render json: { user: user, token: token }
      end

      # passthru 用（未使用）
      def passthru
        render json: { error: "Not implemented" }, status: 404
      end
    end
  end
end
