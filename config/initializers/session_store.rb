Rails.application.config.session_store :cookie_store,
  key: "_myapp_session",
  domain: nil, # ローカルでは絶対に nil
  secure: false, # ローカルなら false
  same_site: :none,
  httponly: true
