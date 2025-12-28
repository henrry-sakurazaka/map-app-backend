class ApplicationController < ActionController::API
  # API向けの認証フィルター
  before_action :authenticate_user!

  # JWTトークンからユーザーを復元して `@current_user` にセットします
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last

    unless token
      render json: { error: 'Unauthorized: No token provided' }, status: :unauthorized and return
    end

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError => e
      # JWTデコードエラー処理
      render json: { error: "Unauthorized: #{e.message}" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      # ユーザーが見つからない場合のエラー処理
      render json: { error: 'Unauthorized: User not found.' }, status: :unauthorized
    end
  end

  # ----------------------------------------------------
  # ゲストログインに必要なメソッド
  # ----------------------------------------------------
    private

    # 新しいJWTトークンを生成するメソッド
    def jwt_token(user)
        # 1. ペイロードの定義 (user_idと有効期限)
        # 24時間後を有効期限とする
        payload = { user_id: user.id, exp: 24.hours.from_now.to_i } 
        
        # 2. JWTのエンコードと返却
        # 秘密鍵としてRailsのシークレットキーを使用
        JWT.encode(payload, Rails.application.secret_key_base)
    end

    # ユーザー情報をJSONレスポンス用に整形するメソッド
    def user_response(user)
        {
            id: user.id,
            name: user.name,
            email: user.email,
            provider: user.provider 
            # 他に必要な属性があればここに追加
        }
    end
end