Rails.application.routes.draw do
  resources :articles
  root to: "articles#index"

  get "pexels/search", to: "pexels#search", as: :pexels_search

  get "media", to: "media_library#index", as: :media_library
  delete "media/:id", to: "media_library#destroy", as: :media_library_destroy
  get "media/:id/download", to: "media_library/download_redirects#show", as: :media_library_download

  get "up", to: "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker", to:  "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Authentication
  resources :registrations, only: [:new, :create]
  resources :sessions, only: [:new, :create]
  get "logout", to: "sessions#destroy", as: :logout

  namespace :settings do
    resource :account, only: [:edit]
    resource :password, only: [:edit, :update]
    resource :personal_details, only: [:edit, :update]
  end
end
