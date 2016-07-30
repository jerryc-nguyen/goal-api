Rails.application.routes.draw do

  namespace :api do
    resources :users, only: [:index, :create, :update, :delete]
    resources :goals
  end

  root to: "api#index", via: :all
end
