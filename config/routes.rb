Rails.application.routes.draw do
  get 'welcome/index'

  get 'sessions/new'
  post 'sessions/create'
  delete 'sessions/destroy'

  
  resources :users 

  resources :articles do
  		resources :comments
  	end
 	
 	resources :comments do
    resources :comments
  end	

  root 'welcome#index'

end
