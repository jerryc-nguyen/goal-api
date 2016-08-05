Rails.application.routes.draw do

  namespace :api do
    
    scope path: "auth" do
      post "facebook", to: "auth#facebook"
    end

    resources :users, except: [:new, :edit]

    resources :goals, except: [:new, :edit] do
      member do
        post :invite
      end

      collection do
        get :pending_accept
        get :home_timeline
        get :user_timeline
      end
    end

    resources :friends, only: [:index] do
      collection do
        get :suggested
      end
    end

    resources :friendships, only: [:destroy] do
      collection do
        get :incomming
        get :outgoing
        post :request_friend
        post :accept_friend
        post :reject_friend
      end
    end

    resources :categories, except: [:new, :edit]
    
  end

  root to: "api#index", via: :all
end
