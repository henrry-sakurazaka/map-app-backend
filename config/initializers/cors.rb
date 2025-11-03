# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    allowed_origins = []

    if Rails.env.development?
      # React (CRA) or Vite どちらでも許可
      allowed_origins << 'http://localhost:3000'
      allowed_origins << 'http://localhost:5173'
    elsif Rails.env.production?
      allowed_origins << ENV.fetch('FRONTEND_URL', 'https://your-app-name.netlify.app')
    end

    origins(*allowed_origins)

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end
