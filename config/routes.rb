# frozen_string_literal: true

Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  root 'home#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    resources :enrollments, only: %i[new create]
  end
  resources :users, only: %i[index edit show update]
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'
end
