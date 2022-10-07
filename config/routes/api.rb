

namespace :api do
  namespace :v1 do
    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
    end
    resources :posts
    resources :comments, only: [:create, :destroy, :update]

    get '/users/me', to: 'users#me'
    get '/users', to: 'users#index'
  end
end

scope :api do
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
  end
end