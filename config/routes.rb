Rails.application.routes.draw do
  resources :passwords, param: :token
  # Defines the root path route ("/")
  root "events#index"

  resources :tenants
  resources :events
  resources :matches
  resources :candidates do
    member do
      get   'thumb'
      get   'big_thumb'
    end
  end
  resources :miscs do
    collection do
      delete  :destroy_all_votes
    end
  end
  resources :rank_slots
  resources :ranks
  resources :match_candidates
  resources :stages do
    member do
      get   'show_vote'
      get   'qr'
    end
  end
  resources :users
  resources :votes do
    collection do
      get   :new
      post  :create
      get   :voted
    end
  end
  resource  :session

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
