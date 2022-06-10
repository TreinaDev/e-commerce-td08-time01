Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  root 'home#index'

  resources :products, only: [:show]
end
