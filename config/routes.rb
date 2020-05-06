Rails.application.routes.draw do
  get 'ingredients/index'
  get 'ingredients/show'
  get 'ingredients/update'
  get 'ingredients/destroy'
  resources :subscribers
  resources :menus
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
