Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root to: "subjects#index"

  resource :profile, only: :show

  resources :subject_groups, only: :show

  resources :approvables, only: [] do
    resource :approval, only: [:create, :destroy]
  end

  resources :subjects do
    collection do
      get :all
    end
  end

  resource :user_onboardings, only: :update

  resources :current_optional_subjects, only: :index

  resources :academic_histories, only: [:new, :create, :index]

  resources :planned_subjects, only: [:index, :create, :destroy], param: :subject_id
end
