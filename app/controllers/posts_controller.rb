class PostsController < InheritedResources::Base

  def index
    @chat = Chat.find(params[:id])
    subreddit = @chat.subreddit + @chat.subreddit_sorting
    limit = @chat.limit
    time = @chat.time
    service = RedditService::RedditClient.new.receive_posts(subreddit, limit, time, params[:after_token],[:before_token])
    @posts = service[:posts]
    @after_token = service[:after_token]
    @before_token = service[:before_token]
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
    chat_id = post.chat.id
    chat = post.chat.name
    image = Cloudinary::Uploader.upload(ActiveStorage::Blob.service.send(:path_for, post.image.key), resource_type: :auto) if post.image.present?
    service = TelegramService::TelegramClient.new(chat)
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
          redirect_to my_posts_path(chat_id) and return
          #TODO flesh error, gif too big
        else
          service.send_animation(file, post.body)
        end
      end
      service.send_photo(valid_image(link, 95), post.body) if post.link.include?(".jpeg") or post.link.include?(".jpg") or post.link.include?(".png")
      service.send_video(link, post.body) if link.include?(".mp4")
    end

    if post.published_at?
      flash[:notice] = 'Post was send'
      redirect_to my_posts_path(chat_id)
    else
      flash.now[:alert] = 'You cannot send this post'
      redirect_to my_posts_path(chat_id)
    end
  end

  def published
    chat = Chat.find(params[:id])
    @posts = Post.published.where(user_id: current_user.id, chat_id: chat.id)
    render :my_posts
  end

  def unpublished
    chat = Chat.find(params[:id])
    @posts = Post.unpublished.where(user_id: current_user.id, chat_id: chat.id)
    render :my_posts
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
