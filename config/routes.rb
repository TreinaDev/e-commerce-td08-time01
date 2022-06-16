Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  root 'home#index'

  resources :products, only: [:show] do
    post 'update_status', on: :member
  end
  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update]

  resources :users, shallow: true do
    resources :cart_items, only: [:create, :index, :destroy]
  end
end
