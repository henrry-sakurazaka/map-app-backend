class ApplicationController < ActionController::API
    def authorize_request
        header = request.headers["Authorization"]
        token = header.split(" ").last if header
        begin
            decode = JWT.decode(token, Rails.application.secret_key_base)[0]
            @current_user = User.find(decode["user_id"])
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound => ease
            render json: { error: "Unauthorized: #{e.massage}" }, status: :unauthorized
        end
    end
end
