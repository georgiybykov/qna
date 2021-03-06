# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    get 'users/auth/failure', to: 'devise/sessions#new'
  end

  resource :oauth_email_confirmation, only: %i[new create]

  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :revoke_vote
    end
  end

  concern :commented do
    post :comment, on: :member
  end

  resources :questions,
            concerns: %i[voted commented] do
    resources :answers,
              concerns: %i[voted commented],
              shallow: true,
              except: %i[index new show] do
      patch :set_best,
            on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
