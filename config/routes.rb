Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "subjects#index"

  resources :subjects do
    member do
      patch :approve
    end
    collection do
      get 'list' => 'subjects#list_subjects', as: :list
    end
  end
end
