# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    allowed_origins = []

    if Rails.env.development?
      allowed_origins << 'http://localhost:3000'  # React CRA
      allowed_origins << 'http://localhost:5173'  # Vite
    elsif Rails.env.production?
      allowed_origins << ENV.fetch('FRONTEND_URL', 'https://your-app-name.netlify.app')
    end

    origins(*allowed_origins)

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false # Cookie/セッションを使う場合
  end
end
