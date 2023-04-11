Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: :auth
  resources :todos do
    member do
      patch :complete
    end
  end
  root 'todos#index'
end
