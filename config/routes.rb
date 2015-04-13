Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # get 'swatches/new'
  root 'lacquers#index'

  # get 'swatches/create'

  # get 'swatches/destroy'
  #delete '/transactions/:id', to: 'transactions#destroy', as: :loan

  match 'login', to: redirect('/auth/facebook'), via: [:get, :post]
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  resources :swatches, only: [:index, :new, :create, :destroy]

  resources :sessions, :only => [:create, :destroy]

  resources :lacquers do
    get :autocomplete_name, on: :collection
  end

  resources :brands

  resources :users

  get 'users/:id/live_notifications' => 'users#live_notifications'

  get 'users/:id/user_lacquers/:id' => 'users#user_lacquers'

  get 'brands/:id/lacquers/:id' => 'brands#lacquer'

  get 'random' => 'user_lacquers#random'
  
  resources :transactions

  resources :user_lacquers

  resources :friendships

  post 'favorites' => 'favorites#create', as: :new_favorite

  delete 'favorites' => 'favorites#destroy', as: :destroy_favorite

  get 'lacquer_search' => 'lacquers#search'

  get 'user_search' => 'users#search'

  get 'new_invite' => "users#new_invite"

  post 'invite_friends' => "users#invite_friends"

end
