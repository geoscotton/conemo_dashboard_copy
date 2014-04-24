Rails.application.routes.draw do
  scope "/:locale" do
    devise_for :users
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  get "/:locale" => "dashboards#index", as: :dashboard

  root to: "dashboards#index"
end
