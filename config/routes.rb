Rails.application.routes.draw do
  get 'sessions/new'
  post 'sessions/create'
  delete 'sessions/destroy'

  
  get 'welcome/index'
  resources :users 
  	resources :articles do
  		resources :comments
  	end
 
  root 'welcome#index'

end
