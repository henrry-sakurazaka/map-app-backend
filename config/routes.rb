Rails.application.routes.draw do 
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "login",    to: "auth#login"
        post "register", to: "auth#register"
        post "guest",    to: "guest#create"
        get  "current_user", to: "auth#current"
      end

      # OmniAuth
      get  "oauth/:provider",          to: "omniauth_callbacks#passthru"
      get  "oauth/:provider/callback", to: "omniauth_callbacks#callback"

      # その他API
      get "reverse-geocode", to: "reverse_geocode#index"
      get "ogp_preview",     to: "ogp_preview#show"
      resources :stores, only: [:index]
    end
  end
end



# Rails.application.routes.draw do
#   namespace :api do
#     namespace :v1 do

#       # --- SessionsController ---
#       post "auth/login",    to: "sessions#create"
#       post "auth/register", to: "sessions#register"

#       # --- GuestController ---
#       namespace :auth do
#         post "guest", to: "auth/guest#create"
#       end

#       # --- Current user ---
#       get "auth/current_user", to: "auth#current"

#       # --- OmniAuth ---
#       get  "oauth/:provider",          to: "omniauth_callbacks#passthru"
#       get  "oauth/:provider/callback", to: "omniauth_callbacks#callback"

#       # --- その他API ---
#       get "reverse-geocode", to: "reverse_geocode#index"
#       get "ogp_preview",     to: "ogp_preview#show"
#       resources :stores, only: [:index]
#     end
#   end

#   get "up" => "rails/health#show", as: :rails_health_check
# end
