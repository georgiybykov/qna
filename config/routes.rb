# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :revoke_vote
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, shallow: true, except: %i[index new show] do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
