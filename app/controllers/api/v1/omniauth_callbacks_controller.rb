module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      # callback と passthru は認証不要
      skip_before_action :authenticate_user!, only: [ :callback, :passthru ]

      # OAuth コールバック
      def callback
        auth = request.env["omniauth.auth"]
        provider = params[:provider]

        # ユーザー作成または取得
        user = User.find_or_create_by(provider: provider, uid: auth.uid) do |u|
          u.name      = auth.info.name.presence || "#{provider.capitalize}User"
          u.email     = auth.info.email.presence || "no_email_#{SecureRandom.hex(4)}@example.com"
          u.image_url = auth.info.image.presence
          u.password  = SecureRandom.hex(10)
        end

        token = generate_jwt(user)

        frontend_url = ENV.fetch("FRONTEND_URL", "http://localhost:5173")
        Rails.logger.info "=== FRONTEND_URL: #{frontend_url.inspect} ==="
        if frontend_url !~ %r{^https?://}
          Rails.logger.warn "=== FRONTEND_URL missing scheme (http/https): #{frontend_url.inspect} ==="
        end
        # 注意: FRONTEND_URL の形式が誤っているとリダイレクト先が壊れます（例: http://localhost3000 のように ':' が抜ける）
        redirect_to "#{frontend_url}/oauth-callback?token=#{token}", allow_other_host: true
      end

      # passthru 用（未使用だが Rails の新仕様で存在が期待される）
      # OmniAuth が実際の provider ルート (/api/v1/oauth/:provider) を処理するので
      # ここでは未実装で 404 を返すだけにする
      def passthru
        # render json: { error: "Not implemented" }, status: :not_found
      end
    end
  end
end
