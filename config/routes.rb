require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'users/sessions'}


  authenticated :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  resource :news, except: [:destroy]

  get '/admin' => 'admin#show'
  root to: 'home#show'
end
