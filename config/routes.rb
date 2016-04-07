Rails.application.routes.draw do
  mount TokenAuth::Engine => '/'
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  resource :version, only: :show

  namespace "api", constraints: { format: 'json' }  do
    get "lessons" => "lessons#index"
  end

  scope "/(:locale)" do
    devise_for :users

    get "/participants/:participant_id/first_contacts/missed_appointment" => "first_contacts#missed_appointment", as: :missed_appointment

    resources :nurses, only: [] do
      resources :supervision_contacts, only: [:new, :create]
      resources :supervision_sessions, only: [:index, :new, :create]
      resources :supervisor_notifications, only: [] do
        collection do
          put :clear
        end
      end
      resource :tasks_summary, only: :show
    end

    resources :participants, except: [:index, :show] do
      resources :additional_contacts, only: [:new, :create]
      resource :call_to_schedule_final_appointment, only: [:new, :create, :edit, :update]
      resource :clinical_summary, only: :show
      resource :final_appointment, only: [:new, :create, :edit, :update]
      resource :first_contact, only: [:new, :create, :edit, :update]
      resource :first_appointment, only: [:new, :create, :edit, :update]
      resources :help_messages, only: [:update]
      resources :help_request_calls, only: [:new, :create]
      resources :lack_of_connectivity_calls, only: [:new, :create]
      resources :non_adherence_calls, only: [:new, :create]
      resources :patient_contacts, only: [:new, :create, :destroy]
      resource :second_contact, only: [:new, :create, :edit, :update]
      resource :smartphone, only: [:new, :create, :edit, :update]
      resources :tasks, only: :index do
        resources :scheduled_task_cancellations, only: [:new, :create]
        resources :scheduled_task_reschedulings, only: [:new, :create]
        member do
          put :resolve
          post :notify_supervisor
          delete :clear_latest_supervisor_notification
        end
      end
      resource :third_contact, only: [:new, :create, :edit, :update]
    end

    namespace "pending" do
      resources  :participants, only: :index
      get "activate/:id" => "participants#activate", as: :activate
      get "enroll/:id" => "participants#enroll", as: :enroll
    end
    
    namespace "active" do
      resources :participants, only: :show
      get "report/:id" => "participants#report", as: :report
    end

    resources :lessons do
      resources :slides
    end
    post "lessons/:id/slide_order" => "lessons#slide_order", as: :lesson_slide_order

    resource :nurse_supervisor_dashboard, only: :show
    resource :nurse_dashboard, only: :show

    get "/" => "dashboards#index", as: :dashboard

    root to: "dashboards#index"
  end

  # catch all for unrecognized routes
  get "*unknown", to: redirect("/404")
  post "*unknown", to: redirect("/404")
end
