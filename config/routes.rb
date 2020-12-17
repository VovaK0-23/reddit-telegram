Rails.application.routes.draw do
  resources :posts
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'signup', to: 'users#new'
  resource :users, except: [:new]
  root to: 'users#new'
end
