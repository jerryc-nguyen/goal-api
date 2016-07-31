Rails.application.routes.draw do

  namespace :api do
    
    scope path: "auth" do
      post "facebook", to: "auth#facebook"
    end

    resources :users, except: [:edit]
    resources :goals, except: [:edit]
    
  end

  root to: "api#index", via: :all
end
