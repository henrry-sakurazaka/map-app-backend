# config/routes.rb

Rails.application.routes.draw do
  # APIバージョン1を定義
  namespace :api do
    get "reverse-geocode", to: "reverse_geocode#index"
    get "ogp_preview", to: "ogp_preview#show"
    get "stores_controller", to: "stores_controller#index"
    namespace :v1 do
      # GET /api/v1/stores に対応するルートを定義
      resources :stores, only: [:index]    
    end
  end
   # アプリケーションの健全性チェック用のルート（そのまま残す）
  get "up" => "rails/health#show", as: :rails_health_check
  # その他のルートがあれば追記
end