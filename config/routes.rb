Rails.application.routes.draw do
  get 'categories/index'
  get 'categories/show'
  get 'categories/new'
  get 'categories/create'
  get 'categories/edit'
  get 'categories/update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'

  resources :products do 
    resources :order_items
  end

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"

  #Category
  resources :categories, except: :destroy

  #Merchant
  delete "/logout", to: "merchants#destroy", as: "logout"
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"

  #Order_Items
  resources :order_items, only: [:index, :create, :update, :destroy, :show]

  #Orders
  resources :orders, only: [:index, :show]

  # shopping cart
  get '/cart', to: 'orders#cart', as: 'cart'
  patch '/checkout', to: 'orders#checkout', as: 'checkout'

end
