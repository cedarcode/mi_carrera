Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "subjects#index"

  resource :profile, only: :show

  resources :subject_groups, only: :show

  resources :subjects do
    member do
      get :able_to_enroll, format: 'json'
      patch :approve
    end
    collection do
      get :all
      get 'list' => 'subjects#list_subjects', as: :list
    end
  end

  resources :accounts, only: [:new, :edit] do
    collection do
      get :create_callback
      get :update_callback
    end
  end
end
