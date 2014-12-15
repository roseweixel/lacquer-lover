Rails.application.routes.draw do
  # get 'swatches/new'

  # get 'swatches/create'

  # get 'swatches/destroy'

  resources :swatches, only: [:index, :new, :create, :destroy]



  root 'lacquers#index'

  resources :sessions, :only => [:create, :destroy]

  resources :lacquers

  resources :brands

  resources :users
  
  resources :transactions

  resources :user_lacquers

  resources :friendships

  delete '/transactions/:id', to: 'transactions#destroy', as: :loan

  get '/users/:id/api', to: 'users#get_notifications'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]


end
