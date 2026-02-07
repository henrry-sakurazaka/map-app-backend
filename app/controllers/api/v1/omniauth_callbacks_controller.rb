module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      # callback と passthru は認証不要
      skip_before_action :authenticate_user!, only: [ :callback, :passthru ]
    def callback
      Rails.logger.info "=== CALLBACK CONTROLLER HIT ==="

      auth = request.env["omniauth.auth"]
      frontend_url = ENV.fetch("FRONTEND_URL", "http://localhost:5173")

      unless auth
        Rails.logger.error "=== OMNIAUTH.AUTH IS NIL ==="
        redirect_to "#{frontend_url}/login?error=oauth_failed",
                    allow_other_host: true
        return
      end

      provider = auth.provider
      uid = auth.uid

      Rails.logger.info "=== PROVIDER: #{provider} / UID: #{uid} ==="

      user = User.find_or_create_by(provider: provider, uid: uid) do |u|
        u.name      = auth.info.name.presence || "#{provider.capitalize}User"
        u.email     = auth.info.email.presence || "no_email_#{SecureRandom.hex(4)}@example.com"
        u.image_url = auth.info.image.presence
        u.password  = SecureRandom.hex(10)
      end

      token = generate_jwt(user)

      Rails.logger.info "=== FRONTEND_URL: #{frontend_url.inspect} ==="

      redirect_to "#{frontend_url}/oauth-callback?token=#{token}",
                  allow_other_host: true
      end
    end
  end
end
