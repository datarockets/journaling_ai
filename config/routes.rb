Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      get "current_user" => "users#show"
      post "users" => "users#create"

      resources :journal_entries, except: [:destroy, :new, :edit, :show]
      get "journal_entries/:date" => "journal_entries#show"
      get "home" => "home#index"
      get "journal" => "journal#index"
      get "profile/statistics" => "profile#statistics"
      get "profile/trends" => "profile#trends"
    end
  end
end
