#frozen_string_liternal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'main#index'
  resources :product, only: [:show]
  resources :category, only: [:show]
  resource :cart, only: %i[destroy show] do
    resources :cart_items, only: %i[destroy create]
  end
  resources :search, only: [:index]
end
