require "sidekiq/web"
Sidekiq::Web.app_url = "/"

Rails.application.routes.draw do
  resources :posts
  namespace :admin do
    resources :users, only: [:index] do
      member do
        patch :approve
      end
    end
  end
  resources :videos
  # add videos/:id/processed route
  resources :videos do
    member do
      get 'processed'
      get 'processing'
      get 'error'
    end
  end
  devise_for :users
  get 'welcome/index'
  get 'welcome/faq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'


    
# Allows us to use link_to for session destroy
  devise_scope :user do
    get "/users/sign_out", as: "sign_out", to: "devise/sessions#destroy"
  end

  devise_scope :user do
    authenticated :user do
      mount Sidekiq::Web => '/sidekiq'
    end
  end


end
