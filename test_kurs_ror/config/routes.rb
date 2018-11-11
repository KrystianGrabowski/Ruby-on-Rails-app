Rails.application.routes.draw do
  devise_for :users
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
  resources :comments

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
