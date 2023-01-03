Rails.application.routes.draw do
  resources :articles do
    resources :comments
  end

  resources :comments do
    resources :comments
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #get '/comments/' , to: 'comments#index'

  # Defines the root path route ("/")
  #root "articles#index"
  resources :users
  post '/users/login', to: 'users#login'
end
