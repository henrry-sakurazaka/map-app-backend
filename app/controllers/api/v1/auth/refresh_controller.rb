# app/controllers/api/v1/auth/refresh_controller.rb
module Api
  module V1
    module Auth
      class RefreshController < ApplicationController
        def refresh
          user = current_user_from_cookie
          token = generate_jwt(user)
          render json: { user:, token: }
        end
      end
    end
  end
end
