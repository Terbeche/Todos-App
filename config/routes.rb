# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'

  resources :todos

  root to: 'todos#index'
end
