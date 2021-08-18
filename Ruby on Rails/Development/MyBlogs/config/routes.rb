Rails.application.routes.draw do

  devise_for :users
	root to: "home#index"
 
  get 'about/new'
  get 'terms/new'
  


  get 'contacts' => 'contacts#new'
  resources :contacts, only: [:create]
  resources :articles do
  	resources :comments
  end
end