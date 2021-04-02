class PostsController < InheritedResources::Base

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def index
    service = RedditService::RedditClient.receive_posts(
        set_chat.subreddit + set_chat.subreddit_sorting,
        set_chat.limit,
        set_chat.time,
        params[:after_token], params[:before_token]
      )
    @posts = service[:posts]
    @after_token = service[:after_token]
    @before_token = service[:before_token]
  end

  def create
    @post = Post.create(post_params)

    if @post.persisted?
      flash[:notice] = t('.success')
    else
      post = Post.find_by_link(@post.link)
      flash[:error] = if post.auto_posted == true
                        t('.bot')
                      else
                        t('.error')
                      end
    end
    redirect_to posts_path
  end

  def destroy
    post = Post.find(params[:id])
    chat = post.chat
    post.destroy
    flash.notice= t('.error')
    redirect_to my_posts_path(chat.id)
  end

  def sort_posts
    Post.where(user_id: current_user.id, chat_id: set_chat.id).order(:created_at).reverse_order.page(params[:page])
  end

  def my_posts
    @posts = sort_posts
  end

  def auto_posted
    @posts = my_posts.auto_posted
    render :my_posts
  end

  def published
    @posts = sort_posts.published.not_auto_posted
    render :my_posts
  end

  def unpublished
    @posts = sort_posts.unpublished
    render :my_posts
  end

  def publish
    post = Post.find(params[:id])
    post.update(published_at: Time.zone.now)
    chat = post.chat
    if post.image.present?
      image = Cloudinary::Uploader.upload(ActiveStorage::Blob.service.send(:path_for, post.image.key), resource_type: :auto)
    end
    service = TelegramService::TelegramClient
    link = post.link

    if link.blank?
      if post.image.blank?
        service.send_message(chat.name, post.body)
      else
        service.send_photo(chat.name, image['secure_url'], post.body)
      end
    else
      if link.include?('.gif')
        file = PublisherService.valid_gif(link)
        if file == false
          flash[:alert] = t('.gif_too_big')
          redirect_to my_posts_path(chat.id) and return
        else
          service.send_animation(chat.name, file, post.body)
        end
      end
      if post.link.include?('.jpeg') or post.link.include?('.jpg') or post.link.include?('.png')
        service.send_photo(chat.name, PublisherService.valid_image(link, 95), post.body)
      end
      service.send_video(chat.name, link, post.body) if link.include?('.mp4')
    end

    if post.published_at?
      flash[:notice] = t('.success')
    else
      flash.now[:alert] = t('.error')
    end
    redirect_to my_posts_path(chat.id)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at, :user_id, :image, :chat_id, :link)
  end
end
