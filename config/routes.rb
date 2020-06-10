Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'orders#index'

  resources :products do 
    resources :order_items
  end

  resources :order_items
  resources :orders
end
