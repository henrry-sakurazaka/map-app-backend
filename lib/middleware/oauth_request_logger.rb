class OauthRequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path.start_with?("/api/v1/oauth")
      Rails.logger.info "=== MIDDLEWARE: PATH=#{req.path} QUERY=#{req.query_string} ==="
      Rails.logger.info "=== MIDDLEWARE: HEADER Cookie=#{env['HTTP_COOKIE'].inspect} ==="

      if env["rack.session"]
        Rails.logger.info "=== MIDDLEWARE: RACK SESSION keys=#{env['rack.session'].keys.inspect} ==="
        Rails.logger.info "=== MIDDLEWARE: RACK SESSION['omniauth.state']=#{env['rack.session']['omniauth.state'].inspect} ==="
      else
        Rails.logger.info "=== MIDDLEWARE: RACK SESSION not available ==="
      end
    end

    @app.call(env)
  end
end
