# app/controllers/api/v1/auth/guest_controller.rb//////////////
module Api
  module V1
    module Auth
      class GuestController < ApplicationController
        def create
          user = User.find_or_create_by!(email: "guest@example.com") do |u|
            u.name = "Guest User"
            u.provider = "local"
            u.uid = SecureRandom.uuid
            u.password = SecureRandom.hex(10)
          end

          token = jwt_token(user)
          render json: { user: user_response(user), token: token }, status: :ok
        end
      end
    end
  end
end
