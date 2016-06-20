Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :mindmaps, only: [:index, :create, :show, :update, :destroy], defaults: { format: 'json' }
      resources :ideas, only: [:index], defaults: { format: 'json' }
    end
  end
end
