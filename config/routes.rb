# frozen_string_literal: true

Rails.application.routes.draw do
  resources :enrollments
  root 'home#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :courses do
    resources :lessons
    resources :enrollments, only: %i[new create]
  end
  resources :users, only: %i[index edit show update]
  get 'activity', to: 'home#activity'
end
