Rails.application.routes.draw do
  get 'articles/index'
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  #root route is also mapped to the index action of ArticlesController
  # root "articles#index"
  root "builds#index"

  # adding a route to our routes file
  #declares that GET /articles requests are mapped to the index action of ArticlesController
  # get "/articles", to: "articles#index"
  get "/articles", to: "articles#index"
  resources :articles
  resources :items
  resources :builds
  resources :build_items

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # Devise recommends this VVVVV
  # root "posts#index"
end
