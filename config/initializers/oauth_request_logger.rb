# Log cookies and rack.session for OAuth routes before OmniAuth middleware runs
require Rails.root.join("lib/middleware/oauth_request_logger")

# Insert after ActionDispatch::Session::CookieStore so rack.session is available
Rails.application.config.middleware.insert_after ActionDispatch::Session::CookieStore, OauthRequestLogger
