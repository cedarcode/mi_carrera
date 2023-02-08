Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

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
end
