Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  root 'home#index'

  resources :products, only: [:show] do
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
  end

  namespace :api do
    namespace :v1 do
      patch 'payment_results', to: 'payments#results'
    end
  end
end
