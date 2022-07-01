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
  resources :promotions, only: [:index, :show, :create]

  resources :users, shallow: true do
    resources :cart_items, only: [:index, :create, :destroy]
    resources :orders, only: [:index, :show, :new, :create] do
      patch 'coupon', on: :collection
    end
    get 'buy_rubis', to: 'buy_rubis#new'
    post 'buy_rubis', to: 'buy_rubis#buy'
  end

  namespace :admin do
    resources :products, only: [:index]
    resources :exchange_rates, only: [:index] 
    post 'collect_rate', to: 'exchange_rates#collect_rate'
  end

  namespace :api do
    namespace :v1 do
      patch 'payment_results', to: 'payments#results'
    end
  end

  namespace :admin do
    resources :orders, only: [:index, :show]
    resources :products, only: [:index, :new, :create, :edit, :update] do
      resources :prices, only: [:new, :create, :edit, :update, :destroy]
    end
  end
end
