Rails.application.routes.draw do

  namespace :api do
    
    scope path: "auth" do
      post "facebook", to: "auth#facebook"
    end

    resources :users, except: [:edit]
    resources :goals, except: [:edit]
    resources :friends, only: [:index]

    resources :friendships, only: [:destroy] do
      collection do
        get :incomming
        get :outgoing
        post :request_friend
        post :accept_friend
        post :reject_friend
      end
    end

  end

  root to: "api#index", via: :all
end
