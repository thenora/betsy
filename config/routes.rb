Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'

  resources :products do 
    resources :order_items
  end

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"

  resources :order_items
  resources :orders

  # shopping cart
  get '/cart', to: 'orders#cart', as: 'cart'
end
