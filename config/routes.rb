# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  resources :courses do
    resources :lessons
  end
  resources :users, only: %i[index edit show update]
  get 'home/activity'
end
