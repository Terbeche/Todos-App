Rails.application.routes.draw do
  devise_for :users, skip: [:passwords, :registrations]

  resources :todos

  root to: 'todos#index'
end
