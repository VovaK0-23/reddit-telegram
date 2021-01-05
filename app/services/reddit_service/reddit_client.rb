require 'reddit/base'

module RedditService
  class RedditClient
    def initialize
      client = Reddit::Base::Client.new(user: ENV['REDDIT_USERNAME'], password: ENV['REDDIT_PASSWORD'])
      @client = client
    end

    def receive_posts(subreddit)
      posts = client.get(subreddit, nocache: true).body.data.children
      a = posts.map { |post| post.extract!("data").values }
      a.first.first['NAME_OF_PARAM']
    end
  end
end
