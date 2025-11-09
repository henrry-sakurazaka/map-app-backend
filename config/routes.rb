Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # --- 通常ログイン / 登録系 ---
      post "auth/login",    to: "sessions#create"
      post "auth/register", to: "sessions#register"

      # --- ゲストログイン ---
      namespace :auth do
        post :guest, to: "guest#create"
      end

      # --- OmniAuth ---
      get "oauth/:provider",          to: "omniauth_callbacks#passthru"
      get "oauth/:provider/callback", to: "omniauth_callbacks#callback"

      # --- その他API ---
      get "reverse-geocode", to: "reverse_geocode#index"
      get "ogp_preview",     to: "ogp_preview#show"
      resources :stores, only: [:index]
    end
  end

  # 健康チェック
  get "up" => "rails/health#show", as: :rails_health_check
end
