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

  root 'welcome#index'

end
