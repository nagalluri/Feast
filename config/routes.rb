Rails.application.routes.draw do
  get 'welcome/index'
  resources :users
  resources :groups, param: :access_token do
  	resources :users, path: '/results'
  end



  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
