require 'reddit/base'

module RedditService
  class RedditClient
    def initialize
      @client = Reddit::Base::Client.new(user: ENV['REDDIT_USERNAME'], password: ENV['REDDIT_PASSWORD'])
    end

    def receive_posts(subreddit)
      @client.get(subreddit, nocache: true).body.data.children.map { |post| post.extract!("data").values }
    end
  end
end
