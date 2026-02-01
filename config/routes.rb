Rails.application.routes.draw do
  # --- OAuth & API ---
  get "/auth/:provider", to: "api/v1/omniauth_callbacks#passthru",
      constraints: { provider: "line" }
  get "/auth/:provider/callback", to: "api/v1/omniauth_callbacks#callback"

  namespace :api do
    namespace :v1 do
      get "/api/v1/oauth/:provider/callback", to: "api/v1/omniauth_callbacks#callback"
      get  "oauth/:provider", to: "omniauth_callbacks#passthru"
      get  "oauth/:provider/callback", to: "omniauth_callbacks#callback"
      post "auth/login",        to: "auth/auth#login"
      post "auth/register",     to: "auth/auth#register"
      post "auth/guest",        to: "auth/guest#create"
      get  "auth/current_user", to: "auth/auth#current"

      get "reverse-geocode", to: "reverse_geocode#index"
      get "ogp_preview",     to: "ogp_preview#show"

      resources :stores, only: [ :index ]
    end
  end

  # --- フロント用ルート ---
  get "home/index"           # HomeController#index 用ルート
  root to: "home#index"      # root_path が生成される

  # React/Vite 用 catch-all
  get "*path", to: "home#index", constraints: ->(req) {
    !req.path.starts_with?("/rails/active_storage")
  }
end
