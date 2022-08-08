# frozen_string_literal: true

Rails.application.routes.draw do
  resources :lessons
  root 'home#index'
  devise_for :users
  resources :courses
  resources :users, only: %i[index edit show update]
  get 'home/activity'
end
