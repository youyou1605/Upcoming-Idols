Rails.application.routes.draw do
  namespace :admin do
    root 'homes#top'
    resources :posts,only: [:index,:show,:edit,:update,:create]
    resources :customers,only: [:index,:show,:edit,:update]
  end
namespace :public do
    resources :customers, only: [:show, :index, :edit, :create, :update] do
      resource :relationships, only: [:create, :destroy]
      member do
        get :followings, :followers
      end
    end
    resources :posts, only: [:show, :index, :edit, :create, :update, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    get 'search' => 'searches#search'
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }
  devise_for :customer, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  root 'homes#top'
  get '/home/about' => 'homes#about', as: 'about'

  devise_scope :customer do
    post 'public/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
