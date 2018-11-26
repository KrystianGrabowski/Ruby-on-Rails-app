Rails.application.routes.draw do
  get 'users/index'
  get 'bookings/user_bookings'
  get 'comments/reported'
  devise_for :users
  resources :bookings do
    member do
      get :restore
    end
  end
  delete 'users/:id', to: 'users#destroy', as: :admin_destroy_user
  resources :products
  resources :products do
    member do
      get :down
      post 'down'
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :models
  root 'pages#home'
  get 'pages/about'
  get 'pages/home'
  get 'pages/contact'
  resources :comments do
    member do
      post :create
    end
  end
  resources :comments do
    member do
      get :report
      get :undo_report
    end
  end
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
