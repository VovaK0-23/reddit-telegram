class PostsController < InheritedResources::Base

  def index
    subreddit = Chat.find(params[:id]).subreddit
    @posts =  RedditService::RedditClient.new.receive_posts(subreddit)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at, :user_id, :image, :chat_id)
  end

end
