require 'reddit/base'

module RedditService
  class RedditClient
    def initialize
      @client = Reddit::Base::Client.new(user: ENV['REDDIT_USERNAME'], password: ENV['REDDIT_PASSWORD'])
    end

    def receive_posts(subreddit, after_token = nil, before_token = nil)
      client = @client.get(subreddit, "after"=> after_token, "before"=> before_token, "limit"=> 10 , nocache: true).body.data
      return { posts: client.children.map { |post| post.extract!("data").values },
               after_token: client.after, before_token: client.before }
    end
  end
end
