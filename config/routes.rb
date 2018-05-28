Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }

  get '/users/test', to: 'users#test', as: 'user_test'
  scope '/admin' do
    get '/users', to: 'users#index', as: 'user'
    resource :users
  end
end
