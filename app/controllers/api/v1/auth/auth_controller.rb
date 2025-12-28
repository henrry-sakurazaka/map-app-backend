# app/controllers/api/v1/auth/auth_controller.rb
module Api
  module V1
    module Auth
      class AuthController < ApplicationController
        # 公開エンドポイント（ログイン・ゲストなど）は認証不要
        skip_before_action :authenticate_user!, only: [:guest, :login]

        # JWTなどで認証している場合、ヘッダーのトークンを使って認証
        before_action :authenticate_user!, only: [:current]

        # GET /api/v1/auth/current_user
          def current
            # ヘッダーに JWT があればデコードして current_user をセット
            token = request.headers["Authorization"]&.split(" ")&.last
            if token
              begin
                decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
                @current_user = User.find(decoded["user_id"])
              rescue
                # デコードに失敗しても無視して nil のまま
                @current_user = nil
              end
            end

            if current_user
              render json: {
                id: current_user.id,
                name: current_user.name,
                email: current_user.email,
                provider: current_user.provider,
                uid: current_user.uid,
                image_url: current_user.image_url
              }
            else
              render json: {} # ログインしてなければ空オブジェクトを返すだけ
            end
          end

          def authenticate_user!
            header = request.headers["Authorization"]
            if header
              token = header.split(" ").last
              decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
              @current_user = User.find(decoded["user_id"])
            else
              @current_user = current_user_from_session
            end
          end

          def login
            user = User.find_by(email: params[:email])
            if user&.authenticate(params[:password])
              token = generate_jwt(user)
              render json: { user: user_json(user), token: token }
            else
              render json: { error: "Invalid email or password" }, status: :unauthorized
            end
          end

          # POST /api/v1/auth/guest
          def guest
            user = User.create_guest!
            token = generate_jwt(user)
            render json: { user: user_json(user), token: token }
          end

          private

        # ユーザー情報をJSON用に整形
          def user_json(user)
            {
              id: user.id,
              name: user.name,
              email: user.email,
              provider: user.provider,
              uid: user.uid,
              image_url: user.image_url
            }
          end

        # JWT生成例
          def generate_jwt(user)
            payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
            JWT.encode(payload, Rails.application.credentials.secret_key_base)
          end

          def current_user
            @current_user
          end
        end
      end
    end
  end
