class ApplicationController < ActionController::API
  # API向けの認証フィルター//////
  before_action :authenticate_user!

  attr_reader :current_user

  JWT_SECRET = Rails.application.secret_key_base


  private

  def generate_jwt(user)
    payload = {
      user_id: user.id,
      exp: 30.minutes.from_now.to_i
    }
    JWT.encode(payload, JWT_SECRET, "HS256")
  end

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render json: { error: "Unauthorized: No token provided" }, status: :unauthorized unless token

    begin
      decoded = JWT.decode(token, JWT_SECRET, true, { algorithm: "HS256" })[0]
      @current_user = User.find_by(id: decoded["user_id"])
    rescue
      @current_user = nil
    end
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      provider: user.provider
    }
  end
end
