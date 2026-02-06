Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope(path_names: { new: "nueva", edit: "editar" }) do
    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    devise_for :users, path: "usuarios", controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations',
      passkeys: 'users/passkeys',
    }, path_names: {
      sign_in: 'iniciar_sesion',
      sign_out: 'cerrar_sesion',
      sign_up: 'registrarse',
      password: 'contraseña',
    }

    devise_scope :user do
      scope path: "usuarios", module: "users", as: "user" do
        resources :passkeys, only: [:index]
        resource :degrees, only: [:edit, :update], path: "carreras"
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

    namespace :planner do
      resources :not_planned_subjects, only: :index
    end

    resource :user_onboardings, only: :update

    resources :current_semester_subjects, path: "materias_semestre_actual", only: :index

    resources :transcripts, path: "escolaridades", only: [:new, :create]

    resources :reviews, only: [:create]

    resources :subject_plans, path: "materias_planeadas", only: [:index, :create, :update, :destroy], param: :subject_id

    resources :planned_semesters, only: [:create]

    if Rails.env.development?
      mount Lookbook::Engine, at: "/lookbook"
    end
  end
end
