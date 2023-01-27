Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root to: "subjects#index"

  resource :profile, only: :show

  resources :subject_groups, only: :show

  resources :subjects do
    member do
      patch :approve
    end
    collection do
      get :all
    end
  end
end
