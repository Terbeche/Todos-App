# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  devise_for :users, skip: %i[passwords registrations]

  resources :todos

  root to: 'todos#index'
end
