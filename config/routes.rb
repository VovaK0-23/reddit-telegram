require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
  post 'chats/:id/posts', to: 'posts#create', as: :create_post
  get 'chats/:id/my_posts', to: 'posts#my_posts', as: :my_posts
  delete 'chats/:id/my_posts', to: 'posts#destroy', as: :delete_post

  post 'post/:id/publish', to: 'posts#publish', as: :publish
  get 'chats/:id/my_posts/published', to: 'posts#published', as: :published
  get 'chats/:id/my_posts/unpublished', to: 'posts#unpublished', as: :unpublished
  get 'chats/:id/my_posts/auto_posted', to: 'posts#auto_posted', as: :auto_posted

  post 'chats/:id/publisher', to: 'publisher#update', as: :auto_posting
end
