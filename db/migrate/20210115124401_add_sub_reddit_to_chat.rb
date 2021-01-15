class AddSubRedditToChat < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :subreddit, :string
  end
end
