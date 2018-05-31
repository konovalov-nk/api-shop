Rails.application.routes.draw do
  resources :order_items
  resources :orders
  resources :products
  devise_for :users, controllers: {
      registrations: 'sessions/registrations',
  }, defaults: { format: :json }

  get '/users/test', to: 'users#test', as: 'user_test'
  get '/users/show/:id', to: 'users#show', as: 'user_show'

  # Cart
  post '/cart/create', to: 'cart#create', as: 'cart_create'

  scope '/admin' do
    get '/users', to: 'users#index', as: 'user'
    resource :users
  end
end
