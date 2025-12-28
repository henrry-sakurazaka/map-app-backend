# OmniAuth 2.x: GET によるリクエスト開始を許可（フロントからの GET に対応させる）
OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.full_host = lambda do |env|
    # Cloudflare 経由の API URL を優先
    ENV.fetch('API_BASE_URL') do
      # フォールバック（ローカル直叩き用）
      request = Rack::Request.new(env)
      "#{request.scheme}://#{request.host_with_port}"
    end
  end

  # Google
  provider :google_oauth2,
           ENV['GOOGLE_CLIENT_ID'],
           ENV['GOOGLE_CLIENT_SECRET'],
           scope: 'email,profile',
           access_type: 'offline',
           prompt: 'select_account',
           setup: true

  # LINE
  provider :line,
           ENV['LINE_CLIENT_ID'],
           ENV['LINE_CLIENT_SECRET'],
           scope: 'profile openid email',
           bot_prompt: 'aggressive',
           path_prefix: '/api/v1/oauth',
           setup: true

  # Apple（※ Apple は redirect_uri 明示が必要なので触らない）
  provider :apple,
           ENV['APPLE_CLIENT_ID'],
           '',
           {
             scope: 'email name',
             team_id: ENV['APPLE_TEAM_ID'],
             key_id: ENV['APPLE_KEY_ID'],
             pem: ENV['APPLE_PEM_PATH'],
             redirect_uri: "#{ENV.fetch('FRONTEND_URL', 'http://localhost:5173')}/api/v1/auth/apple/callback",
             path_prefix: '/api/v1/oauth',
             setup: true
           }

   OmniAuth.config.path_prefix = '/api/v1/oauth'
end


# セッションを使わない設定（そのままでOK）
OmniAuth.config.allowed_request_methods = [:get, :post]

# セッションを使わない設定（そのままでOK）
OmniAuth.config.request_validation_phase = lambda { |_env| true }

