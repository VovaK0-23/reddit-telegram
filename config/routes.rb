Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#home'
  get 'chats/:id', to: 'chats#show', as: :chats
  get 'chats', to: 'chats#new', as: :new_chat
  post 'chats', to: 'chats#create', as: :create_chat
  # delete 'chats/:id', to: 'chats#destroy', as: :delete_chat
end
