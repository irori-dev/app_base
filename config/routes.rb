require 'sidekiq/web'

Rails.application.routes.draw do

  root 'home#index'

  resources :cats
  mount Sidekiq::Web, at: '/sidekiq' if Rails.env.development?
end
