Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, skip: [:passwords, :registrations]

  resources :todos

  root to: 'todos#index'
end
