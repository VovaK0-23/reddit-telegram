ActiveAdmin.register Post do
  permit_params %i[title body published_at user_id image chat_id]

  scope :all
  scope :published
  scope :unpublished

  action_item :publish, only: :show do
    link_to post.published_at? ? 'Send again' : 'Publish', publish_admin_post_path(post), method: :put
  end

  member_action :publish, method: :put do
    post = Post.find(params[:id])
    post.update(published_at: Time.zone.now)
    chat_id = post.chat.name
    # image = Rails.application.routes.url_helpers.rails_blob_url(post.image)
    image = Cloudinary::Uploader.upload(ActiveStorage::Blob.service.send(:path_for, post.image.key), resource_type: :auto) if post.image.present?
    service = TelegramService::TelegramClient.new(chat_id)
    service.send_photo(image["secure_url"]) if post.image.present?
    service.send_message(post.body) if post.body.present?
    redirect_to admin_post_path(post)
  end
  form do |f|
    f.inputs do
      f.input :title
      f.input :user
      f.input :chat
      f.input :body
      f.input :published_at
      f.input :image, as: :file
    end
    f.actions
  end
  # member_action :unpublish, method: :put do
  #   post = Post.find(params[:id])
  #   post.update(published_at: nil)
  #   redirect_to admin_post_path(post)
  # end
end
