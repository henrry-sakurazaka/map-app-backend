Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get  "oauth/:provider", to: "omniauth_callbacks#passthru"
      get  "oauth/:provider/callback", to: "omniauth_callbacks#callback"
      post "auth/login",        to: "auth/auth#login"
      post "auth/register",     to: "auth/auth#register"
      post "auth/guest",        to: "auth/guest#create"
      get  "auth/current_user", to: "auth/auth#current"

      get "reverse-geocode", to: "reverse_geocode#index"
      get "ogp_preview",     to: "ogp_preview#show"

      resources :stores, only: [:index]
    end
  end
end





