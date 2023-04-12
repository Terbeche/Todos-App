# frozen_string_literal: true

Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: :auth
  resources :todos do
    post :update_positions, on: :collection
    post :toggle_completed, on: :member
  end
  root 'todos#index'
end
