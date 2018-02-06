require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # mount Sidekiq::Web => '/sidekiq'

  root 'pages#home'
  resources :campaigns, except: [:new] do
    #campaigns/:id/raffle
    post 'raffle', on: :member
    #campaigns/raffle
    # post 'raffle', on: :collection
  end
  get 'members/:token/opened', to: 'members#opened'
  resources :members, only: [:create, :destroy, :update]
end
