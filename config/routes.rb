require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do

  devise_for :users
  mount Sidekiq::Web => '/sidekiq'

  mount ActionCable.server => '/cable'

  resource :news, except: [:destroy]

  get '/admin' => 'admin#show'
  root to: 'home#show'
end
