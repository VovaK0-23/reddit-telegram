require 'reddit/base'

module RedditService
  class RedditClient
    def self.receive_posts(subreddit, limit, time, after_token = nil, before_token = nil)
      client = REDDIT_CLIENT.get(subreddit, t: time, after: after_token, before: before_token, limit: limit, count: limit, nocache: true).body.data
      { posts: client.children.map { |post| post.extract!("data").values.first },
        after_token: client.after, before_token: client.before }
    end

    def self.publisher_receive_posts(subreddit, time, after_token)
      client = REDDIT_CLIENT.get(subreddit, t: time, after: after_token, limit: 100, count: 100, nocache: true).body.data
      { posts: client.children.map { |post| post.extract!("data").values.first },
        after_token: client.after }
    end
  end
end
