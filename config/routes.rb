Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'products#index'

  resources :products do 
    resources :order_items
  end

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"

  #Order_Items
  resources :order_items, only: [:index, :create, :update, :destroy, :show]

  #Orders
  resources :orders, only: [:index, :show]

  # shopping cart
  get '/cart', to: 'orders#cart', as: 'cart'
end
