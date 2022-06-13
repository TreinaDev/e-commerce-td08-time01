Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  root 'home#index'

  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update]

end
