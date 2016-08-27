Rails.application.routes.draw do

  namespace :api do
    
    scope path: "auth" do
      post "facebook", to: "auth#facebook"
    end

    resources :users, except: [:new, :edit]  do
      collection do
        get :home_timeline
      end

      member do
        get :timeline
      end
    end

    resources :goals, except: [:new, :edit] do
      member do
        post :like_toggle
        post :comment
        get :comments
      end
    end

    resources :goal_sessions, except: [ :new, :edit ] do
      member do
        post :invite
        post :invite_by_email
        post :accept
        get :suggest_buddies
      end

      collection do
        get :pending_accept
        post :handle_start_end
      end
    end

    resources :friends, only: [:index] do
      collection do
        get :buddies
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
      
    resources :comments, only: [:update, :destroy] do
      member do
        post :like_toggle
      end
    end
    
  end

  root to: "api#index", via: :all
end
