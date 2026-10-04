Rails.application.routes.draw do
  namespace :api do
    resources :employees, only: [:index, :show] do
      patch :salary, action: :update_salary, on: :member
    end
    resource :summary, only: [:show]
    resource :options, only: [:show]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#index"
end
