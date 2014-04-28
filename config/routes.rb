Rails.application.routes.draw do
  scope "/(:locale)" do
    devise_for :users

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    resources :participants, except: [:index, :show]
    
    namespace 'pending' do
      resources  :participants, only: [:index, :show]
    end
    
    namespace 'active' do
      resources :participants, only: [:index, :show]
    end

    resources :lessons do
      resources :slides
    end
  end

  get "/:locale" => "dashboards#index", as: :dashboard

  root to: "dashboards#index"
end
