# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    allowed_origins = []

    if Rails.env.development?
      allowed_origins << 'http://localhost:3000'  # React CRA
      allowed_origins << 'http://localhost:5173'  # Vite
      allowed_origins << 'https://dev-auth.offsetcodecraft.site'
    elsif Rails.env.production?
      allowed_origins << ENV.fetch('FRONTEND_URL', 'https://your-app-name.netlify.app')
    end

    origins(*allowed_origins)

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true # Cookie/セッションを使う場合に必要
  end
end
