# OmniAuth 2.x: GET によるリクエスト開始を許可（フロントからの GET に対応）
OmniAuth.config.allowed_request_methods = [ :get, :post ]

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.full_host = lambda do |env|
    ENV.fetch("API_BASE_URL") do
      # フォールバック（ローカル直叩き用）
      request = Rack::Request.new(env)
      "#{request.scheme}://#{request.host_with_port}"
    end
  end

  # Google
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           scope: "email,profile",
           access_type: "offline",
           prompt: "select_account",
           setup: true

  # LINE
  provider :line,
           ENV["LINE_CLIENT_ID"],
           ENV["LINE_CLIENT_SECRET"],
           scope: "profile openid email",
           bot_prompt: "aggressive",
           setup: true
end

# OmniAuth のエンドポイントを API 配下に変更
OmniAuth.config.path_prefix = "/api/v1/oauth"

# リクエスト検証フェーズを無効化（API-only + SPA 用）
OmniAuth.config.request_validation_phase = lambda { |_env| true }
