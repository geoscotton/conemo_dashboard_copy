Rails.application.routes.draw do
  mount TokenAuth::Engine => '/'
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  resource :version, only: :show

  namespace "api", constraints: { format: 'json' }  do
    get "lessons" => "lessons#index"
    get "dialogues" => "dialogues#index"
  end

  scope "/(:locale)" do
    devise_for :users

    get "/participants/:participant_id/first_contacts/missed_appointment" => "first_contacts#missed_appointment", as: :missed_appointment
    get "/participants/:participant_id/first_appointments/missed_second_contact" => "first_appointments#missed_second_contact", as: :missed_second_contact
    get "/participants/:participant_id/second_contacts/missed_third_contact" => "second_contacts#missed_third_contact", as: :missed_third_contact
    get "/participants/:participant_id/third_contacts/missed_final_appointment" => "third_contacts#missed_final_appointment", as: :missed_final_appointment

    resources :participants, except: [:index, :show] do
      resources :additional_contacts, only: [:new, :create]
      resource :first_contact, only: [:new, :create, :edit, :update]
      resource :first_appointment, only: [:new, :create, :edit, :update]
      resource :second_contact, only: [:new, :create, :edit, :update]
      resource :third_contact, only: [:new, :create, :edit, :update]
      resource :call_to_schedule_final_appointment, only: [:new, :create]
      resource :final_appointment, only: [:new, :create, :edit, :update]
      resource :smartphone, only: [:new, :create, :edit, :update]
      resources :patient_contacts, only: [:new, :create, :destroy]
      resources :help_messages, only: [:update]
      resources :tasks, only: :index
      get "*unknown", to: redirect("/%{locale}/active/participants")
    end

    namespace "pending" do
      resources  :participants, only: :index
      get "activate/:id" => "participants#activate", as: :activate
    end
    
    namespace "active" do
      resources :participants, only: [:index, :show]
      get "report/:id" => "participants#report", as: :report
    end

    resources :dialogues

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
