Rails.application.routes.draw do
  scope "/(:locale)" do
    devise_for :users

    mount RailsAdmin::Engine => "/admin", as: "rails_admin"

    resources :participants, except: [:index, :show] do
      resource :first_contact
      resource :first_appointment
      resource :second_contact
      resource :third_contact
      resource :final_appointment
      resource :smartphone
      resources :patient_contacts, only: [:new, :create, :destroy]
      resources :help_messages, only: [:update]
    end

    get "/participants/:participant_id/first_contacts/missed_appointment" => "first_contacts#missed_appointment", as: :missed_appointment
    get "/participants/:participant_id/first_appointments/missed_second_contact" => "first_appointments#missed_second_contact", as: :missed_second_contact
    get "/participants/:participant_id/third_contact/missed_final_appointment" => "third_contacts#missed_final_appointment", as: :missed_final_appointment

    namespace "pending" do
      resources  :participants, only: :index
      get "activate/:id" => "participants#activate", as: :activate
    end
    
    namespace "active" do
      resources :participants, only: [:index, :show]
      get "report/:id" => "participants#report", as: :report
    end

    resources :lessons do
      resources :slides
    end
    post "lessons/:id/slide_order" => "lessons#slide_order", as: :lesson_slide_order
  end

  get "/:locale" => "dashboards#index", as: :dashboard

  root to: "dashboards#index"
end
