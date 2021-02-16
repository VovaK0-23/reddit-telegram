class PostsController < InheritedResources::Base

  def index
    @chat = Chat.find(params[:id])
    subreddit = Chat.find(params[:id]).subreddit
    @posts =  RedditService::RedditClient.new.receive_posts(subreddit)
  end

  def create
    @post = Post.create(post_params)

    if @post.persisted?
      flash[:notice] = 'Post was saved'
      redirect_to posts_path
    else
      flash.now[:alert] = 'You cannot save this post'
      redirect_to posts_path
    end
  end

  def my_posts
    chat = Chat.find(params[:id])
    @posts = Post.where(user_id: current_user.id, chat_id: chat.id)
  end

  def publish
    post = Post.find(params[:id])
    post.update(published_at: Time.zone.now)
    chat = post.chat.id
    chat_id = post.chat.name
    image = Cloudinary::Uploader.upload(ActiveStorage::Blob.service.send(:path_for, post.image.key), resource_type: :auto) if post.image.present?
    service = TelegramService::TelegramClient.new(chat_id)
    link = post.link

    if link.blank?
      if post.image.blank?
        service.send_message(post.body)
      else
        service.send_photo(image["secure_url"], post.body)
      end
    else
      service.send_photo(valid_image(link, 95), post.body) if post.link.include?(".jpeg") or post.link.include?(".jpg") or post.link.include?(".png")
      service.send_animation(valid_gif(link, 40), post.body) if link.include?(".gif")
      service.send_video(link, post.body) if link.include?(".mp4")
    end

    if post.published_at?
      flash[:notice] = 'Post was send'
      redirect_to my_posts_path(chat)
    else
      flash.now[:alert] = 'You cannot send this post'
      redirect_to my_posts_path(chat)
    end
  end

  def published
    @posts = Post.published
    render :my_posts
  end

  def unpublished
    @posts = Post.unpublished
    render :my_posts
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at, :user_id, :image, :chat_id, :link)
  end

  def resize_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    if image.size <= 5242880
      return image.path
    end
    image.resize(resize_value.to_s + '%')
    resize_image(link, resize_value - 5)
  end

  def resize_gif(link, resize_value)
    gif = MiniMagick::Image.open(link)
    if gif.size <= 20971520
      return gif.path
    end
    gif.resize(resize_value.to_s + '%')
    resize_gif(link, resize_value - 5)
  end

  def valid_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    if image.size <= 5242880
    return link
    end
    resize_image(link, resize_value)
  end

  def valid_gif(link, resize_value)
    gif = MiniMagick::Image.open(link)
    if gif.size <= 20971520
      return link
    end
    resize_gif(link, resize_value)
  end

end
