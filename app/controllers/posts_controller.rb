class PostsController < InheritedResources::Base

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def index
    service = RedditService::RedditClient.new.receive_posts(
        set_chat.subreddit + set_chat.subreddit_sorting,
        set_chat.limit,
        set_chat.time,
        params[:after_token],[:before_token])
    @posts = service[:posts]
    @after_token = service[:after_token]
    @before_token = service[:before_token]
  end

  def create
    @post = Post.create(post_params)

    if @post.persisted?
      flash[:notice] = t('.success')
      redirect_to posts_path
    else
      post = Post.find_by_link(@post.link)
      if post.auto_posted == true
        flash[:error] = t('.bot')
        redirect_to posts_path
      else
        flash[:error] = t('.error')
        redirect_to posts_path
      end
    end
  end

  def sort_posts
    Post.where(user_id: current_user.id, chat_id: set_chat.id).order(:created_at).reverse_order.page(params[:page])
  end

  def my_posts
    @posts = sort_posts
  end

  def published
    @posts = sort_posts.published
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
    image = Cloudinary::Uploader.upload(ActiveStorage::Blob.service.send(:path_for, post.image.key), resource_type: :auto) if post.image.present?
    service = TelegramService::TelegramClient.new(chat.name)
    link = post.link

    if link.blank?
      if post.image.blank?
        service.send_message(post.body)
      else
        service.send_photo(image["secure_url"], post.body)
      end
    else
      if link.include?(".gif")
        file = valid_gif(link)
        if file == false
          flash[:alert] = t('.gif_too_big')
          redirect_to my_posts_path(chat.id) and return
        else
          service.send_animation(file, post.body)
        end
      end
      service.send_photo(valid_image(link, 95), post.body) if post.link.include?(".jpeg") or post.link.include?(".jpg") or post.link.include?(".png")
      service.send_video(link, post.body) if link.include?(".mp4")
    end

    if post.published_at?
      flash[:notice] = t('.success')
      redirect_to my_posts_path(chat.id)
    else
      flash.now[:alert] = t('.error')
      redirect_to my_posts_path(chat.id)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at, :user_id, :image, :chat_id, :link)
  end

  def resize_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    if image.size > 10485760
      image = MiniMagick::Image.new(image.path)
      while image.size > 10485760
        image.resize(resize_value.to_s + '%')
        resize_value - 5
      end
    end
    return Faraday::UploadIO.new(image.path, image.type)
  end

  def resize_gif(link)
    gif = MiniMagick::Image.open(link)
    if gif.size <= 52428800
      return Faraday::UploadIO.new(gif.path, gif.type)
    else
      return false
    end
  end

  def valid_image(link, resize_value)
    image = MiniMagick::Image.open(link)
    if image.size <= 5242880
    return link
    end
    resize_image(link, resize_value)
  end

  def valid_gif(link)
    gif = MiniMagick::Image.open(link)
    if gif.size <= 20971520
      return link
    end
    resize_gif(link)
  end

end
