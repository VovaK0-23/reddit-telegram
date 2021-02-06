Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'pages#home'
  get 'chats', to: 'chats#index', as: :chats
  get 'chats/new', to: 'chats#new', as: :new_chat
  post 'chats/new', to: 'chats#create', as: :create_chat
  get 'chats/:id', to: 'chats#show', as: :chat
  get 'chats/:id/edit', to: 'chats#edit', as: :edit_chat
  delete 'chats/:id', to: 'chats#destroy', as: :delete_chat
  put 'chats/:id/edit', to: 'chats#update', as: :update_chat

  get 'chats/:id/posts', to: 'posts#index', as: :posts
end
