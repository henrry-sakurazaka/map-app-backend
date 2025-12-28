# Configure session cookie for OAuth flows (supports external HTTPS hosts)
# - If the API_BASE_URL is https (e.g. dev-auth.offsetcodecraft.site via cloudflared), require secure cookies
# - You can also explicitly force secure cookies with SESSION_COOKIES_SECURE=true

secure_cookie = if ENV['SESSION_COOKIES_SECURE']
  ENV['SESSION_COOKIES_SECURE'] == 'true'
else
  (ENV['API_BASE_URL'] || '').start_with?('https') || Rails.env.production?
end

# determine cookie domain explicitly so we can log it
cookie_domain = ENV['API_BASE_URL'] ? :all : (Rails.env.production? ? :all : nil)
Rails.logger.info "=== Session cookie settings: secure=#{secure_cookie.inspect}, domain=#{cookie_domain.inspect}, same_site=:none ==="

Rails.application.config.session_store :cookie_store,
  key: "_myapp_session",
  domain: cookie_domain,
  secure: secure_cookie,
  same_site: :none,    # OAuth リダイレクトで必要
  httponly: true

