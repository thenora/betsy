# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'

  resources :products do
    resources :order_items
  end

  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'merchants#create'

  # Category
  resources :categories, except: :destroy

  # Merchant
  delete '/logout', to: 'merchants#destroy', as: 'logout'
  get '/dashboard', to: 'merchants#dashboard', as: 'dashboard'
  resources :merchants, only: %i[index show]

  # Order_Items
  resources :order_items, only: %i[index create update destroy show]

  # Orders
  resources :orders, only: %i[index show update]

  # shopping cart
  get '/cart', to: 'orders#cart', as: 'cart'
  get '/checkout', to: 'orders#checkout', as: 'checkout'
  get '/confirmation', to: 'orders#confirmation', as: 'confirmation'
end
