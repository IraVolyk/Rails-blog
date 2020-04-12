Rails.application.routes.draw do
  get 'welcome/index'
  get 'sessions/new'
  post 'sessions/create'
  delete 'sessions/destroy'

  resources :users 

  resources :articles do
  		resources :comments, only: [:create, :destroy]
  	end

 	resources :comments, only: [:create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end	

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  root 'welcome#index'

end
