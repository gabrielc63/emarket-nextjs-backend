Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
    path: "v1/users",
    path_names: {
      sign_in: "sign_in",
      sign_out: "sign_out",
      registration: ""
    },
    defaults: { format: :json },
    controllers: {
      registrations: "v1/users/registrations",
      sessions: "v1/users/sessions"
    }

  namespace "v1", defaults: { format: "json" } do
    get "current_user", to: "current_users#show"
    patch "current_user", to: "current_users#update"
    post "refresh", to: "refresh_tokens#create"
    resources :products, only: %i[index show]
    resources :wishlists, only: %i[index show create update destroy] do
      resources :wishlist_items, only: %i[create destroy]
    end
  end
end
