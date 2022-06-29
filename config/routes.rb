Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  root 'home#index'

  resources :products, only: [:show] do
    resources :prices, only: [:new, :create, :edit, :update, :destroy]
    get 'by_category', on: :collection
    post 'update_status', on: :member
    get 'search', on: :collection
  end
  
  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update]

  resources :users, shallow: true do
    resources :cart_items, only: [:index, :create, :destroy]
    resources :orders, only: [:index, :show, :new, :create]
    get 'buy_rubis', to: 'buy_rubis#new'
    post 'buy_rubis', to: 'buy_rubis#buy'
  end

  namespace :admin do
    resources :products, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      patch 'payment_results', to: 'payments#results'
    end
  end

  namespace :admin do
    resources :products, only: [:index, :new, :create, :edit, :update]
  end
end
