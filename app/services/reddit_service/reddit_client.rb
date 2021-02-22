require 'reddit/base'

module RedditService
  class RedditClient
    def initialize
      @client = Reddit::Base::Client.new(user: ENV['REDDIT_USERNAME'], password: ENV['REDDIT_PASSWORD'])
    end

    def receive_posts(subreddit, limit, time, after_token = nil, before_token = nil)
      client = @client.get(subreddit, "t"=> time, "after"=> after_token, "before"=> before_token, "limit"=> limit, nocache: true).body.data
      return { posts: client.children.map { |post| post.extract!("data").values },
               after_token: client.after, before_token: client.before }
    end
  end
end
