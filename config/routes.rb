Rails.application.routes.draw do
  resources :ingredients
  resources :subscribers
  resources :menus
  resources :businesses
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
