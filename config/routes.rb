Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/new_account', to: 'static_pages#new_account'
  get '/transaction', to: 'transactions#new'
  resources :users
  resources :accounts #, only: [:create, :destroy, :update, :get]
  resources :transactions
end
