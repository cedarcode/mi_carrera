Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope(path_names: { new: "nueva", edit: "editar" }) do
    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    devise_for :users, path: "usuarios", controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations'
    }, path_names: {
      sign_in: 'iniciar_sesion',
      sign_out: 'cerrar_sesion',
      sign_up: 'registrarse',
      password: 'contraseña',
    }

    scope path: "usuarios", module: "users", as: "user" do
      resources :passkeys, only: [:index, :create, :destroy] do
        post :callback, on: :collection
      end
    end

    root to: "subjects#index"

    resource :profile, path: "perfil", only: :show

    resources :subject_groups, path: "grupos", only: :show

    resources :approvables, only: [] do
      resource :approval, only: [:create, :destroy]
    end

    resources :subjects, path: "materias" do
      collection do
        get :all, path: "todas"
      end
    end

    resource :user_onboardings, only: :update

    resources :current_optional_subjects, path: "materias_inco_semestre_actual", only: :index

    resources :transcripts, path: "escolaridades", only: [:new, :create]

    resources :reviews, only: [:create, :destroy]

    resources :subject_plans, path: "materias_planeadas", only: [:index, :create, :update, :destroy], param: :subject_id

    if Rails.env.development?
      mount Lookbook::Engine, at: "/lookbook"
    end
  end
end
