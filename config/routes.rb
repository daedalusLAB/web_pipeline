Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'


    
# Allows us to use link_to for session destroy
  devise_scope :user do
    get "/users/sign_out", as: "sign_out", to: "devise/sessions#destroy"
  end

  
end
