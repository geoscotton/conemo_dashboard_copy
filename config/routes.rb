Rails.application.routes.draw do
  scope "/(:locale)" do
    devise_for :users

    mount RailsAdmin::Engine => "/admin", as: "rails_admin"

    resources :participants, except: [:index, :show] do
      resource :first_contact
      resource :first_appointment
      resource :second_contact
      resource :smartphone
    end

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
