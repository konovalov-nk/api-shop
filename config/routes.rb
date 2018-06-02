Rails.application.routes.draw do
  # resources :ipns
  # resources :webhooks
  # resources :order_items
  # resources :orders
  # resources :products
  devise_for :users, controllers: {
      registrations: 'sessions/registrations',
  }, defaults: { format: :json }

  get '/users/test', to: 'users#test', as: 'user_test'
  get '/users/show/:id', to: 'users#show', as: 'user_show'

  # Cart
  post '/cart', to: 'cart#create', as: 'cart_create'
  put '/cart', to: 'cart#update', as: 'cart_update'
  get '/cart', to: 'cart#index', as: 'cart_get'

  # PayPal webhooks
  post '/webhook/paypal', to: 'webhook#paypal', as: 'paypal_webhook'
  post '/webhooks/paypal', to: 'webhook#paypal', as: 'paypal_webhooks'
  post '/webhook/paypal_ipn', to: 'webhook#paypal_ipn', as: 'paypal_ipn'

  scope '/admin' do
    get '/users', to: 'users#index', as: 'user'
    resource :users
  end
end
