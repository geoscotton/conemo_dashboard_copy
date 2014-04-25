Rails.application.routes.draw do
  scope "/:locale" do
    devise_for :users

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    resources :participants, only: [:edit, :update, :destroy]
    
    namespace 'pending' do
      resources  :participants, except: [:edit, :update, :destroy]
    end
    
    namespace 'active' do
      resources :participants, only: [:index, :show]
    end
  end

  get "/:locale" => "dashboards#index", as: :dashboard

  root to: "dashboards#index"
end
