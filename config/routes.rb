Rails.application.routes.draw do
	root "pages#index"

  use_doorkeeper
  devise_for :users
	# get '*path', to: 'pages#index', via: :all
  draw :api

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
