Rails.application.routes.draw do
  # get 'swatches/new'
  root 'lacquers#index'

  # get 'swatches/create'

  # get 'swatches/destroy'
  #delete '/transactions/:id', to: 'transactions#destroy', as: :loan

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  resources :swatches, only: [:index, :new, :create, :destroy]

  resources :sessions, :only => [:create, :destroy]

  resources :lacquers

  resources :brands

  resources :users

  get 'users/:id/live_notifications' => 'users#live_notifications'

  get 'users/:id/user_lacquers/:id' => 'users#user_lacquers'
  
  resources :transactions

  resources :user_lacquers

  resources :friendships

end
