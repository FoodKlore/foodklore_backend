Rails.application.routes.draw do
  resources :shoppingcart_items
  resources :orders
  resources :shoppingcart
  resources :ingredients
  resources :subscribers
  resources :menus
  resources :businesses do
    member do
      get 'menus'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
