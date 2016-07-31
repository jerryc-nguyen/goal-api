Rails.application.routes.draw do

  namespace :api do
    resources :users, except: [:edit]
    resources :goals, except: [:edit]
  end

  root to: "api#index", via: :all
end
