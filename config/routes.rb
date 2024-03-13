require "sidekiq/web"
Sidekiq::Web.app_url = "/"

Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index] do
      member do
        patch :approve
      end
    end
  end
  resources :videos
  devise_for :users
  get 'welcome/index'
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
