# frozen_string_literal: true

Rails.application.routes.draw do
  passwordless_for :users, at: '/', as: :auth
  resources :todos
  
  root 'todos#index'
end
