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

    if post.link.blank?
      if post.image.blank?
        service.send_message(post.body)
      else
        service.send_photo(image["secure_url"], post.body)
      end
    else
      service.send_photo(post.link, post.body) if post.link.include?(".jpeg")
      service.send_animation(post.link, post.body) if post.link.include?(".gif")
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

end
