Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :mindmaps, only: [:index], defaults: { format: 'json' }
    end
  end
end
