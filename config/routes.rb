Rails.application.routes.draw do
  scope "/:locale" do
    devise_for :users
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  get "/:locale" => "dashboards#index", as: :dashboard

  scope "/:locale" do
    resources :participants, only: [:edit, :update, :destroy]
    
    namespace 'pending' do
      resources  :participants, except: [:edit, :update, :destroy]
    end
    
    namespace 'active' do
      resources :participants, only: [:index, :show]
    end
  end

  root to: "dashboards#index"
end
