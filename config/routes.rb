# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    get 'users/auth/failure', to: 'devise/sessions#new'
  end

  resource :oauth_email_confirmation, only: %i[new create]

  root to: 'questions#index'

  get :search, to: 'searches#index'

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

    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # rubocop:disable Naming/VariableNumber
  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit]
      end
    end
  end
  # rubocop:enable Naming/VariableNumber
end
