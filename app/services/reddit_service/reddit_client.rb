require 'reddit/base'

module RedditService
  class RedditClient
    def initialize
      @client = Reddit::Base::Client.new(user: ENV['REDDIT_USERNAME'], password: ENV['REDDIT_PASSWORD'])
    end

    def receive_posts(subreddit, limit, time, after_token = nil, before_token = nil)
      client = @client.get(subreddit, t: time, after: after_token, before: before_token, limit: limit, count: limit, nocache: true).body.data
      { posts: client.children.map { |post| post.extract!("data").values.first },
        after_token: client.after, before_token: client.before }
    end

    def publisher_receive_posts(subreddit, limit, time, after_token)
      client = @client.get(subreddit, t: time, after: after_token, limit: limit, count: limit, nocache: true).body.data
      { posts: client.children.map { |post| post.extract!("data").values.first },
        after_token: client.after}
    end
  end
end
