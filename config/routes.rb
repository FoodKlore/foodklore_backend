Rails.application.routes.draw do
  resources :guests

  get '/authenticate/guest/:guest_token/:token', to: 'guests#authenticate', as: 'authenticate_guest'

  resources :users
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

  # mount(JsonWebTokenMiddleware => '/auth')
  namespace :auth do
    post '/login', to: 'jwt#create'
    delete '/logout', to: 'jwt#destroy'
    get '/logged_in', to: 'jwt#is_logged_in?'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
