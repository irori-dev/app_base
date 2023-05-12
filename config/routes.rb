require 'sidekiq/web'

Rails.application.routes.draw do

  resources :cats, only: %i[index new create edit update destroy]

  root to: 'cats#index'
  get "/login", to:"sessions#new"
  post "/login", to:"sessions#create"
  mount Sidekiq::Web, at: '/sidekiq' if Rails.env.development?
end
