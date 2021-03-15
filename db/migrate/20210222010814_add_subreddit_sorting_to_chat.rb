class AddSubredditSortingToChat < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :subreddit_sorting, :string
  end
end
