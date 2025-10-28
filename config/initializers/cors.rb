# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # 許可するオリジン（URL）のリストを初期化
    allowed_origins = []

    # 開発環境の場合
    if Rails.env.development? || Rails.env.test?
      # localhost:3000 を追加
      allowed_origins << 'http://localhost:3000'
    end

    # 本番環境の場合
    if Rails.env.production?
      # 環境変数から本番URLを取得して追加
      # Railwayで環境変数 FRONTEND_URL を設定することを想定
      if ENV['FRONTEND_URL'].present?
        allowed_origins << ENV['FRONTEND_URL']
      end
    end

    # 許可するオリジンを設定
    origins allowed_origins

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end