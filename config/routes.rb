require 'sidekiq/web'

Rails.application.routes.draw do

  resources :cats
  mount Sidekiq::Web, at: '/sidekiq' if Rails.env.development?
end
