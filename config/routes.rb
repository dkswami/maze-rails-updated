Rails.application.routes.draw do
	root "pages#index"

	namespace :api do
		namespace :v1 do
			resources :posts
			resources :comments, only: [:create, :destroy]
		end
	end

	get '*path', to: 'pages#index', via: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
