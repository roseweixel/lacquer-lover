Rails.application.routes.draw do
  root 'lacquers#index'

  resources :sessions, :only => [:create, :destroy]

  resources :lacquers

  resources :users

  resources :user_lacquers

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

end
